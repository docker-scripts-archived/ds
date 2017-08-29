cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p www
    orig_cmd_create \
        --mount type=bind,src=$(pwd)/www,dst=/var/www/$IMAGE

    _create_new_global_cmd
}

_create_new_global_cmd() {
    local container_dir=$(basename $(pwd))
    local cmdfile=$DSDIR/cmd/$container_dir.sh
    mkdir -p $DSDIR/cmd/
    rm -f $cmdfile
    cp $APP_DIR/cmd/apache2.sh $cmdfile
    sed -i $cmdfile \
        -e "s/cmd_apache2/cmd_$container_dir/g" \
        -e "s#ds exec#ds @$(pwd) exec#g" \
        -e "3 s/apache2/$container_dir/"
}
