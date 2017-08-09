#!/bin/bash

test_script=$(realpath $1); shift
workdir=$(pwd)

test_description="$test_script"
source $(dirname $0)/sharness.sh

export HOME="$workdir/ds-test"
export DSDIR="$HOME/.ds"
mkdir -p $DSDIR
cat <<_EOF > $DSDIR/config.sh
GITHUB=https://github.com/docker-scripts
APPS=$HOME/docker-scripts
CONTAINERS=$HOME/containers
_EOF
source $DSDIR/config.sh

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
