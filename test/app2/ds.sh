cmd_start() {
    echo "Starting container $CONTAINER ..."
    docker start $CONTAINER >/dev/null
}

rename_function cmd_stop orig_cmd_stop
cmd_stop() {
    echo "Stoping container $CONTAINER ..."
    orig_cmd_stop >/dev/null
}

rename_function cmd_restart orig_cmd_restart
cmd_restart() {
    echo "Restarting container $CONTAINER ..."
    orig_cmd_restart >/dev/null
}

rename_function cmd_remove orig_cmd_remove
cmd_remove() {
    local container_dir=$(basename $(pwd))
    rm -f $DSDIR/cmd/$container_dir.sh

    orig_cmd_remove
}
