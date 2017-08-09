cmd_runtest_help() {
    cat <<_EOF
    runtest [-d|--debug] [<test-script.t.sh>...]
        Run the given test scripts. If no test-script is given
        all the test scripts in the working directory will be run.
        Test scripts have the extension '.t.sh'

_EOF
}

cmd_runtest() {
    local verbose=''
    [[ $1 == '-d' || $1 == '--debug' ]] && verbose='--verbose' && shift

    local pattern=${@:-*.t.sh}
    set -e
    local blue='\033[0;34m'
    local nocolor='\033[0m'
    for test_script in $(ls $pattern); do
        [[ ${test_script: -5} == ".t.sh" ]] || continue
        [[ -f "$test_script" ]] || continue
        echo -e "\n${blue}=> $test_script${nocolor}"
        $LIBDIR/runtest.sh $test_script $verbose
    done
}
