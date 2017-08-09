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
    orig_cmd_create \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $APPS/ds:$APPS/ds \
        -v $workdir:$workdir \
        --workdir $workdir
}
