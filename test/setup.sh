# This file should be sourced by all test-scripts

ulimit=$(ulimit -n)
ulimit -n 9000

cd "$(dirname "$0")"
source ./sharness.sh

TEMP_DIR="$SHARNESS_TEST_DIRECTORY/temp"
#rm -rf $TEMP_DIR
export HOME="$TEMP_DIR"
export DSDIR="$HOME"/.ds

mkdir -p $DSDIR
cat <<_EOF > $DSDIR/config.sh
GITHUB=https://github.com/docker-scripts
APPS=$TEMP_DIR/docker-scripts
CONTAINERS=$TEMP_DIR/containers
_EOF
GITHUB="https://github.com/docker-scripts"
APPS="$TEMP_DIR/docker-scripts"
CONTAINERS="$TEMP_DIR/containers"

ulimit -n $ulimit
