cmd_runcfg_help() {
    cat <<_EOF
    $COMMAND [<cfg>]
        Run a configuration script inside the container.

_EOF
}

cmd_runcfg() {
    local cfg=$1
    if [[ -z $cfg ]]; then
        echo -e "Usage:\n$(cmd_runcfg_help)"
        _cmd_runcfg_list
        return 0
    fi

    # get the path of the configuration script
    local cfgscript
    [[ -x $LIBDIR/config/$cfg.sh ]] && cfgscript=$LIBDIR/config/$cfg.sh
    [[ -x $APP_DIR/config/$cfg.sh ]] && cfgscript=$APP_DIR/config/$cfg.sh
    [[ -x ./config/$cfg.sh ]] && cfgscript=./config/$cfg.sh
    [[ -x $cfgscript ]] || fail "\n--> Configuration script '$cfg' not found.\n"

    # copy to a tmp dir and run from inside the container
    rm -rf tmp/
    mkdir tmp/
    cp $cfgscript tmp/
    echo -e "\n--> Running configuration script '$cfgscript'"
    cmd_exec /host/tmp/$(basename $cfgscript)
    rm -rf tmp/
}

_cmd_runcfg_list() {
    # predefined cfg scripts
    local cfgscripts=""
    [[ -d $LIBDIR/config/ ]] && cfgscripts=$(ls $LIBDIR/config/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nPredefined configuration scripts:\n   " $cfgscripts

    # application cfg scripts
    cfgscripts=""
    [[ -d $APP_DIR/config/ ]] && cfgscripts=$(ls $APP_DIR/config/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nApplication configuration scripts:\n   " $cfgscripts

    # container cfg scripts
    cfgscripts=""
    [[ -d ./config/ ]] && cfgscripts=$(ls ./config/)
    cfgscripts="${cfgscripts//.sh/}"
    cfgscripts="$(echo $cfgscripts | sed -e 's/ / ; /g')"
    [[ -n $cfgscripts ]] &&
    echo -e "\nContainer configuration scripts:\n   " $cfgscripts
}
