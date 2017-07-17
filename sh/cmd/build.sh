cmd_build() {
    datestamp=$(date +%F | tr -d -)
    nohup_out=nohup-$CONTAINER-$datestamp.out
    rm -f $nohup_out
    nohup docker build "$@" --tag=$IMAGE --file=$SRC/Dockerfile $SRC/ > $nohup_out &
    sleep 1
    tail -f $nohup_out
}
