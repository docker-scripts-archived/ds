cmd_apache2_help() {
    cat <<_EOF
    apache2 [start|stop|restart|reload]
        Control apache2 inside the container.

_EOF
}

cmd_apache2() {
    local action=$1
    case $action in
        start|stop|restart|reload)
            ds exec service apache2 $action
            ;;
        *)
            echo "$(cmd_apache2_help)"
            ;;
    esac
    echo "Called from container $CONTAINER."
}
