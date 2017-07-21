cmd_info() {
    local format name time size status

    cat <<-_EOF

SETTINGS:
    SRC:       $SRC
    IMAGE:     $IMAGE
    CONTAINER: $CONTAINER
    PORTS:     $PORTS

_EOF

    if [[ -n $IMAGE ]]; then
        format="{{.Repository}}:{{.Tag}},{{.CreatedSince}},{{.Size}}"
        while IFS=, read name time size; do
            cat <<-_EOF
IMAGE:
    Name:      $name
    Created:   $time ago
    Size:      $size

_EOF
        done < <(docker images --format "$format" | grep $IMAGE)
    fi

    if [[ -n $CONTAINER ]]; then
        format="{{.Names}},{{.RunningFor}},{{.Status}}"
        while IFS=, read name time status; do
        cat <<-_EOF
CONTAINER:
    Name:      $name
    Created:   $time ago
    Status:    $status

_EOF
        done < <(docker ps -a --format "$format" | grep $CONTAINER)
    fi
}
