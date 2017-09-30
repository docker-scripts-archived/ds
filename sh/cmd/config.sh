cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    # Run configuration scripts with: # ds inject script.sh
    # Configuration scripts are located at $LIBDIR/scripts/
    # or at $APP_DIR/scripts/ or at $CONTAINER_DIR/scripts/
    :
}
