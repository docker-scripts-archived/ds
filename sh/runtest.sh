#!/bin/bash

test_script=$(realpath $1); shift
workdir=$(pwd)

test_description="$test_script"
source $(dirname $0)/sharness.sh
this_test=${test_script##*/}
this_test=${this_test%.t.sh}

export HOME="$workdir/ds-test"
export DSDIR="$HOME/.ds"
mkdir -p $DSDIR
cat <<_EOF > $DSDIR/config.sh
GITHUB=https://github.com/docker-scripts
APPS=$HOME/docker-scripts
CONTAINERS=$HOME/containers
NETWORK='dsnet-test'
_EOF
source $DSDIR/config.sh
cat <<'_EOF' > $DSDIR/ds.sh
# no option -t to docker exec
cmd_exec() {
    is_up || cmd_start && sleep 2
    docker exec -i $CONTAINER env TERM=xterm "$@"
}
_EOF

description() {
    local str=$1
    local blue='\033[0;34m'
    local nocolor='\033[0m'
    echo -e "${blue}   $str${nocolor}"
}
test_case() {
    test_expect_success "$@"
}

source $test_script
test_done
