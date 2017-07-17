cmd_create() {
    ### configure the host for running systemd containers
    _systemd_config

    cmd_stop
    docker rm $CONTAINER 2>/dev/null

    ### forwarded ports
    local ports=''
    for port in $PORTS; do
        ports+=" -p $port"
    done

    ### create a new container
    docker create --name=$CONTAINER --hostname=$CONTAINER \
        --restart=unless-stopped \
        --cap-add SYS_ADMIN \
        --security-opt apparmor:unconfined \
        --tmpfs /run --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v $(pwd):/host \
        $ports "$@" $IMAGE
}

_systemd_config() {
    ### configure the host for running systemd containers
    if [[ -z $(nsenter --mount=/proc/1/ns/mnt -- mount | grep /sys/fs/cgroup/systemd) ]]; then
        [[ ! -d /sys/fs/cgroup/systemd ]] && mkdir -p /sys/fs/cgroup/systemd
        nsenter --mount=/proc/1/ns/mnt -- mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
    fi
}
