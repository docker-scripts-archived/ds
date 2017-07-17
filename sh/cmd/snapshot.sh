cmd_snapshot() {
    local snapshot="$CONTAINER:$(date +%F)"
    docker rmi $snapshot 2> /dev/null
    rm nohup.out
    nohup docker commit -p -m "Snapshot $snapshot" $CONTAINER $snapshot &

    echo "Saving $CONTAINER to $snapshot"
    sleep 2
}
