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
    [[ -n $SUBNET ]] && subnet="--subnet $SUBNET"
    docker network create $subnet $NETWORK 2>/dev/null

    # remove the container if it exists
    cmd_stop
    docker network disconnect $NETWORK $CONTAINER 2>/dev/null
    docker rm $CONTAINER 2>/dev/null

    # create a new container
    docker create --name=$CONTAINER --hostname=$CONTAINER \
        --restart=unless-stopped \
        --cap-add SYS_ADMIN \
        --security-opt apparmor:unconfined \
        --mount type=tmpfs,destination=/run \
        --mount type=tmpfs,destination=/run/lock \
        --mount type=bind,src=/sys/fs/cgroup,dst=/sys/fs/cgroup,readonly \
        --mount type=bind,source=$(pwd),destination=/host \
        $(_mount_letsencrypt_dirs) \
        $(_published_ports) \
        $(_network_and_aliases) \
        "$@" $IMAGE

    # register domains to wsproxy
    if [[ -n $DOMAIN ]]; then
        local wsproxy=${WSPROXY:-wsproxy}
        ds @$wsproxy domains-add $CONTAINER $DOMAIN $DOMAINS
    fi
}

### Configure the host for running systemd containers.
### See: https://github.com/solita/docker-systemd/blob/master/setup
_systemd_config() {
    if nsenter --mount=/proc/1/ns/mnt -- mount | grep /sys/fs/cgroup/systemd >/dev/null 2>&1; then
        : # do nothing
    else
        [[ ! -d /sys/fs/cgroup/systemd ]] && mkdir -p /sys/fs/cgroup/systemd
        nsenter --mount=/proc/1/ns/mnt -- mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
    fi
}

### mount letsencrypt config dirs
_mount_letsencrypt_dirs() {
    [[ -n $DOMAIN ]] || return

    local wsproxy=${WSPROXY:-wsproxy}
    local certdir="$CONTAINERS/$wsproxy/letsencrypt"
    [[ ${wsproxy:0:1} == '/' ]] && certdir="$wsproxy/letsencrypt"

    local mount_dirs=''
    mount_dirs+=" --mount type=bind,src=$certdir/archive,dst=/etc/letsencrypt/archive,readonly"
    mount_dirs+=" --mount type=bind,src=$certdir/live,dst=/etc/letsencrypt/live,readonly"

    echo "$mount_dirs"
}

### published ports
_published_ports() {
    [[ -n $PORTS ]] || return

    local ports=''
    for port in $PORTS; do
        ports+=" --publish $port"
    done

    echo "$ports"
}

### network and aliases
_network_and_aliases() {
    [[ -n $NETWORK ]] || return

    local network=" --network $NETWORK"
    network+=" --network-alias $CONTAINER"
    if [[ -n $DOMAIN ]]; then
        for domain in $DOMAIN $DOMAINS; do
            network+=" --network-alias $domain"
        done
    fi

    echo "$network"
}
