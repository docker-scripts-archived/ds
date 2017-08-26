cmd_create_help() {
    cat <<_EOF
    create
        Create the docker container.

_EOF
}

cmd_create() {
    # configure the host for running systemd containers
    _systemd_config

    # create a ds network if it does not yet exist
    local subnet=''
    [[ -n $NETWORK ]] && subnet="--subnet $NETWORK"
    docker network create $subnet ds-net 2>/dev/null

    # remove the container if it exists
    cmd_stop
    docker network disconnect ds-net $CONTAINER 2>/dev/null
    docker rm $CONTAINER 2>/dev/null

    # forwarded ports
    local ports=''
    for port in $PORTS; do
        ports+=" -p $port"
    done

    # network aliases
    local network_aliases="--network-alias $CONTAINER"
    [[ -n $DOMAIN ]] && network_aliases+=" --network-alias $DOMAIN"
    if [[ -n $DOMAINS ]]; then
        for domain in $DOMAINS; do
            network_aliases+=" --network-alias $domain"
        done
    fi

    # create a new container
    docker create --name=$CONTAINER --hostname=$CONTAINER \
        --restart=unless-stopped \
        --cap-add SYS_ADMIN \
        --security-opt apparmor:unconfined \
        --tmpfs /run --tmpfs /run/lock \
        --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --volume $(pwd):/host \
        --network ds-net $network_aliases \
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
