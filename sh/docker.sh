#!/bin/bash

set -o pipefail
VERSION="0.9"
LIBDIR="$(dirname "$0")"
source "$LIBDIR/auxiliary.sh"

cmd_version() {
    echo "DockerScripts:$VERSION https://github.com/dashohoxha/ds"
}

cmd_start() {
    docker start $CONTAINER
}

cmd_stop() {
    docker stop $CONTAINER 2>/dev/null
}

cmd_restart() {
    docker restart $CONTAINER
}

cmd_shell() {
    is_up || cmd_start
    cmd_exec bash
}

cmd_exec() {
    is_up || cmd_start
    docker exec -it $CONTAINER env TERM=xterm "$@"
}

cmd_remove() {
    is_up && cmd_stop
    docker rm $CONTAINER 2>/dev/null
    docker rmi $IMAGE 2>/dev/null
}

call() {
    local cmd=$1; shift

    # load the generic command file
    [[ -f "$LIBDIR/${cmd//_//}.sh" ]] && source "$LIBDIR/${cmd//_//}.sh"

    # load the specific command file
    [[ -f "$APP_DIR/${cmd//_//}.sh" ]] && source "$APP_DIR/${cmd//_//}.sh"

    # load the local command file
    [[ -f "${cmd//_//}.sh" ]] && source "${cmd//_//}.sh"

    # run the command
    is_function $cmd || fail "Cannot find command '$cmd'"
    CMD=${cmd#*_}
    COMMAND="$PROGRAM ${CMD//_/ }"
    $cmd "$@"
}

load_ds_config() {
    # read the config file
    DSDIR=${DSDIR:-$HOME/.ds}
    local config_file="$DSDIR/config.sh"
    [[ -f "$config_file" ]] && source "$config_file"

    # set defaults, if configurations are missing
    GITHUB=${GITHUB:-https://github.com/docker-scripts}
    APPS=${APPS:-/opt/docker-scripts}
    CONTAINERS=${CONTAINERS:-/var/ds}
    mkdir -p $APPS $CONTAINERS

    # create the config file, if it does not exist
    if [[ ! -f "$config_file" ]]; then
        mkdir -p "$(dirname "$config_file")"
        cat <<-_EOF > "$config_file"
GITHUB='$GITHUB'
APPS='$APPS'
CONTAINERS='$CONTAINERS'
_EOF
    fi
}

ds_info() {
    cat <<-_EOF

$(cmd_version)

DSDIR='$DSDIR'

--> ls $DSDIR :
$(ls $DSDIR)

--> cat $DSDIR/config.sh :
$(cat $DSDIR/config.sh)

--> ls $APPS:
$(ls $APPS)

--> ls $CONTAINERS:
$(ls $CONTAINERS)

For help about commands try: ds -h

_EOF
}

load_container_settings() {
    [[ -f settings.sh ]] \
        || fail "No file ./settings.sh found."

    # load the settings file
    source ./settings.sh

    [[ -n $APP ]] \
        || fail "No APP defined on ./settings.sh"

    APP_DIR="$APPS/$APP"
    [[ -d $APP_DIR ]] \
        || fail "The app directory '$APP_DIR' does not exist."

    [[ -n $IMAGE ]] \
        || fail "No IMAGE defined on ./settings.sh"
    [[ -n $CONTAINER ]] \
        || fail "No CONTAINER defined on ./settings.sh"
}

main() {
    # check the docker version
    local version=$(docker --version | cut -d, -f1 | cut -d' ' -f3 | cut -d. -f1)
    [[ "$version" -lt 17 ]] && fail "These scripts are supposed to work with docker 17+"

    PROGRAM="${0##*/}"

    # load ~/.ds/config.sh
    load_ds_config

    # handle some basic commands
    local arg1=$1 ; shift
    case $arg1 in
        '')            ds_info ;              exit 0 ;;
        -v|--version)  cmd_version "$@" ;     exit 0 ;;
        -h|--help)     call cmd_help "$@" ;   exit 0 ;;
        pull|init)     call cmd_$arg1 "$@" ;  exit 0 ;;
        -x)            set -x ;;
        @*) # cd to the container directory
            local dir="$CONTAINERS/${arg1:1}"
            [[ -d "$dir" ]] || fail "Container directory '$dir' does not exist."
            cd "$dir"
            ;;
    esac

    # load container settings.sh
    load_container_settings

    # The file 'ds.sh' can be used to redefine
    # and customize some functions, without having to
    # touch the code of the main script.
    [[ -f "$DSDIR/ds.sh" ]] && source "$DSDIR/ds.sh"
    [[ -f "$APP_DIR/ds.sh" ]] && source "$APP_DIR/ds.sh"
    [[ -f ds.sh ]] && source ds.sh

    # run the given command
    case $arg1 in
        start|stop|restart|shell|exec|remove)
            cmd_$arg1 "$@"
            ;;
        *)
            call cmd_$arg1 "$@"
            ;;
    esac
}

main "$@"
