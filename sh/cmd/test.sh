cmd_test_help() {
    cat <<_EOF
    test [-d|--debug] [<test-script.t.sh>...]
        Run the given test scripts inside the ds-test container.
        It actually call the command 'runtest' inside the container
        with the same options and arguments.

_EOF
}

cmd_test() {
    ds pull ds
    ds init ds/test/app @ds-test

    ds @ds-test build
    ds @ds-test create $(pwd)
    ds @ds-test config

    ds @ds-test inject install-ds.sh $APPS/ds
    ds @ds-test exec ds runtest "$@"
    ds @ds-test stop
}
