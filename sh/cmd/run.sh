cmd_run_help() {
    cat <<_EOF
    run [<script>]
        Run a script in the local host.

_EOF
}

cmd_run() {
    local script=$1; shift
    if [[ -z $script ]]; then
        echo -e "Usage:\n$(cmd_inject_help)"
        _print_script_list
        return 0
    fi

    # get the absolute path of the script
    local scrfile
    [[ -x $LIBDIR/scripts/$script ]] && scrfile=$LIBDIR/scripts/$script
    [[ -x $APP_DIR/scripts/$script ]] && scrfile=$APP_DIR/scripts/$script
    [[ -x ./scripts/$script ]] && scrfile=./scripts/$script
    [[ -x $scrfile ]] || fail "\n--> Script '$script' not found.\n"

    echo -e "\n--> Running script '$scrfile'"
    $scrfile "$@"
}

_print_script_list() {
    # predefined scripts
    local script_list=""
    [[ -d $LIBDIR/scripts/ ]] && script_list=$(ls $LIBDIR/scripts/)
    script_list="$(echo $script_list | sed -e 's/ / ; /g')"
    [[ -n $script_list ]] \
        && echo -e "\nPredefined scripts:\n   " $script_list

    # application scripts
    script_list=""
    [[ -d $APP_DIR/scripts/ ]] && script_list=$(ls $APP_DIR/scripts/)
    script_list="$(echo $script_list | sed -e 's/ / ; /g')"
    [[ -n $script_list ]] \
        && echo -e "\nApplication scripts:\n   " $script_list

    # container scripts
    script_list=""
    [[ -d ./scripts/ ]] && script_list=$(ls ./scripts/)
    script_list="$(echo $script_list | sed -e 's/ / ; /g')"
    [[ -n $script_list ]] \
        && echo -e "\nContainer scripts:\n   " $script_list
}
