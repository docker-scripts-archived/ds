cmd_build_help() {
    cat <<_EOF
    build
        Build the docker image.

_EOF
}

cmd_build() {
    log docker build "$@" --tag=$IMAGE $APP_DIR/
}
