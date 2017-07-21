# Configure the container.

cmd_config() {
    cmd_start
    sleep 3

    # Run configuration scripts with: # ds runcfg $cfg
    # Configuration scripts are located either at
    # $LIBDIR/config/ or at $SRC/config/

    cmd_restart
}
