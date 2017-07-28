cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    cmd_start
    sleep 3

    # Run configuration scripts with: # ds runcfg $cfg
    # Configuration scripts are located either at
    # $LIBDIR/config/ or at $APP_DIR/config/

    cmd_restart
}
