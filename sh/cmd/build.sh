cmd_build_help() {
    cat <<_EOF
    build
        Build the docker image.

_EOF
}

cmd_build() {
    # copy docker files to tmp/
    # and preprocess Dockerfile
    rm -rf tmp/
    cp -a $APP_DIR tmp
    m4 -I "$LIBDIR/dockerfiles" $APP_DIR/Dockerfile > tmp/Dockerfile

    # build the image
    log docker build "$@" --tag=$IMAGE tmp/

    # clean up
    rm -rf tmp/
}
