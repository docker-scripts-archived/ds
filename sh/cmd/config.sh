# Configure the container.

cmd_config() {
    cmd_start
    sleep 3

    # apply standard configurations listed on $CONFIG
    for cfg in $CONFIG; do
        [[ -x $LIBDIR/config/$cfg.sh ]] || continue
        rm -rf tmp/
        mkdir tmp/
        cp $LIBDIR/config/$cfg.sh tmp/
        echo -e "\n--> $cfg.sh"
        cmd_exec /host/tmp/$cfg.sh
    done

    # apply custom configuration scripts listed on 'config/'
    rm -rf tmp/
    mkdir tmp
    cp $SRC/config/* tmp/
    for f in $(ls tmp/*.sh); do
        f=$(basename $f)
        [[ -x tmp/$f ]] || continue
        echo -e "\n--> $f"
        cmd_exec /host/tmp/$f
    done
    rm -rf tmp/

    cmd_restart
}
