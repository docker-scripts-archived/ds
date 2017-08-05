cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    is_up || cmd_start && sleep 3

    ds runcfg set_prompt
    ds runcfg apache2

    cmd_restart
}
