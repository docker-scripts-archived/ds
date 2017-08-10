cmd_build_help() {
    cat <<_EOF
    build
        Build the docker image.

_EOF
}

cmd_build() {
    local datestamp=$(date +%F | tr -d -)
    local nohup_out=logs/nohup-$CONTAINER-$datestamp.out
    rm -f $nohup_out
    mkdir -p logs/
    nohup docker build "$@" --tag=$IMAGE $APP_DIR/ 2>&1 | tee $nohup_out &
    wait $!
}
