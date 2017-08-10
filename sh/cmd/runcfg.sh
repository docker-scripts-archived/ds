cmd_runcfg_help() {
    cat <<_EOF
    runcfg [<cfg>]
        Run a configuration script inside the container.

_EOF
}

cmd_runcfg() {
    local cfg=$1; shift
    if [[ -z $cfg ]]; then
        echo -e "Usage:\n$(cmd_runcfg_help)"
        _cmd_runcfg_list
        return 0
    fi

    # get the path of the configuration script
    local cfgscript
    [[ -x $LIBDIR/cfg/$cfg.sh ]] && cfgscript=$LIBDIR/cfg/$cfg.sh
    [[ -x $APP_DIR/cfg/$cfg.sh ]] && cfgscript=$APP_DIR/cfg/$cfg.sh
    [[ -x ./cfg/$cfg.sh ]] && cfgscript=./cfg/$cfg.sh
    [[ -x $cfgscript ]] || fail "\n--> Configuration script '$cfg' not found.\n"

    # copy to a tmp dir and run from inside the container
    rm -rf tmp/
    mkdir tmp/
    cp $cfgscript tmp/
    echo -e "\n--> Running configuration script '$cfgscript'"
    cmd_exec "/host/tmp/$(basename $cfgscript)" "$@"
    rm -rf tmp/
}

_cmd_runcfg_list() {
    # predefined cfg scripts
    local cfgscripts=""
    [[ -d $LIBDIR/cfg/ ]] && cfgscripts=$(ls $LIBDIR/cfg/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nPredefined configuration scripts:\n   " $cfgscripts

    # application cfg scripts
    cfgscripts=""
    [[ -d $APP_DIR/cfg/ ]] && cfgscripts=$(ls $APP_DIR/cfg/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nApplication configuration scripts:\n   " $cfgscripts

    # container cfg scripts
    cfgscripts=""
    [[ -d ./cfg/ ]] && cfgscripts=$(ls ./cfg/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nContainer configuration scripts:\n   " $cfgscripts
}
