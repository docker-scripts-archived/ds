cmd_create_help() {
    cat <<_EOF
    create
        Create the docker container.

_EOF
}

cmd_create() {
    # configure the host for running systemd containers
    _systemd_config

    cmd_stop
    docker rm $CONTAINER 2>/dev/null

    # forwarded ports
    local ports=''
    for port in $PORTS; do
        ports+=" -p $port"
    done

    # create a new container
    docker create --name=$CONTAINER --hostname=$CONTAINER \
        --restart=unless-stopped \
        --cap-add SYS_ADMIN \
        --security-opt apparmor:unconfined \
        --tmpfs /run --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v $(pwd):/host \
        $ports "$@" $IMAGE
}

# Configure the host for running systemd containers.
# See: https://github.com/solita/docker-systemd/blob/master/setup
_systemd_config() {
    if nsenter --mount=/proc/1/ns/mnt -- mount | grep /sys/fs/cgroup/systemd >/dev/null 2>&1; then
        : # do nothing
    else
        [[ ! -d /sys/fs/cgroup/systemd ]] && mkdir -p /sys/fs/cgroup/systemd
        nsenter --mount=/proc/1/ns/mnt -- mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
    fi
}
