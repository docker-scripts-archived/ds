cmd_runcfg_help() {
    cat <<_EOF
    runcfg <cfg>
        Run a configuration script.

_EOF
}

cmd_runcfg() {
    local cfg=$1

    # get the path of the configuration script
    local cfgscript
    [[ -x $LIBDIR/config/$cfg.sh ]] && cfgscript=$LIBDIR/config/$cfg.sh
    [[ -x $SRC/config/$cfg.sh ]] && cfgscript=$SRC/config/$cfg.sh
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
