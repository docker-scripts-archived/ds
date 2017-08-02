cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    cmd_start
    sleep 3

    ds runcfg set_prompt

    cmd_restart
}
