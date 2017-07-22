cmd_build_help() {
    cat <<_EOF
    build
        Build the docker image.

_EOF
}

cmd_build() {
    local datestamp=$(date +%F | tr -d -)
    local nohup_out=nohup-$CONTAINER-$datestamp.out
    rm -f $nohup_out
    nohup docker build "$@" --tag=$IMAGE --file=$SRC/Dockerfile $SRC/ 2>&1 | tee $nohup_out &
    wait $!
}
