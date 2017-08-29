cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    # See: https://www.develves.net/blogs/asd/2016-05-27-alternative-to-docker-in-docker/

    local workdir=${1:-$(pwd)}
    mkdir -p $workdir
    orig_cmd_create \
        --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=$APPS/ds,dst=$APPS/ds \
        --mount type=bind,src=$workdir,dst=$workdir \
        --workdir $workdir
}
