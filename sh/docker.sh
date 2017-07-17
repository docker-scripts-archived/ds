#!/bin/bash

VERSION="0.9"
LIBDIR="$(dirname "$0")"
set -o pipefail

fail() {
    echo -e "$@" >&2
    exit 1
}

cmd_version() {
    echo -e "\nDockerScripts $VERSION    ( https://github.com/dashohoxha/ds )\n"
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
    cmd_start
    cmd_exec bash
}

cmd_exec() {
    docker exec -it $CONTAINER env TERM=xterm "$@"
}

cmd_remove() {
    cmd_stop
    docker rm $CONTAINER 2>/dev/null
    docker rmi $IMAGE 2>/dev/null
}

call() {
    local cmd=$1; shift
    local file="$LIBDIR/$(echo $cmd | tr _ /).sh"
    [[ -f "$file" ]] || file="$SRC/$(echo $cmd | tr _ /).sh"
    [[ -f "$file" ]] || fail "Cannot find command '$cmd'"
    source "$file"
    $cmd "$@"
}

load_settings() {
    [[ -f settings.sh ]] \
        || fail "No file ./settings.sh found."

    # load the settings file
    source ./settings.sh

    [[ -n $SRC ]] \
        || fail "No SRC defined on ./settings.sh"
    [[ -d $SRC ]] \
        || fail "The SRC directory '$SRC' does not exist."
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

    # handle some basic commands
    local cmd="$1" ; shift
    case $cmd in
        v|-v|version|--version)  cmd_version "$@" ; exit 0 ;;
        ''|-h|--help)            call cmd_help "$@" ; exit 0 ;;
        init)                    call cmd_init "$@" ; exit 0 ;;
    esac

    # load settings.sh
    load_settings

    # The file 'ds.sh' can be used to redefine
    # and customize some functions, without having to
    # touch the code of the main script.
    [[ -f "$SRC/ds.sh" ]] && source "$SRC/ds.sh"
    [[ -f ds.sh ]] && source ds.sh

    # run the given command
    case $cmd in
        start|stop|restart|shell|exec|remove)
            cmd_$cmd "$@" ;;
        *)  call cmd_$cmd "$@" ;;
    esac
}

main "$@"
