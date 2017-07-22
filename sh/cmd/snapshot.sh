cmd_snapshot_help() {
    cat <<_EOF
    snapshot
        Make a snapshot of the container.

_EOF
}

cmd_snapshot() {
    local snapshot="$CONTAINER:$(date +%F)"
    docker rmi $snapshot 2> /dev/null
    echo -e "\nMaking a snapshot of $CONTAINER to $snapshot\n"
    nohup docker commit -p -m "Snapshot $snapshot" $CONTAINER $snapshot >/dev/null 2>&1 &
    wait $!
}
