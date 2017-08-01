# This file should be sourced by all test-scripts

cd "$(dirname "$0")"
source ./sharness.sh

CODE="$(dirname "$SHARNESS_TEST_DIRECTORY")"
DS="$CODE"/sh/docker.sh
[[ ! -x $DS ]] && echo "Could not find docker.sh" &&  exit 1

ds() { "$DS" "$@" ; }

#export HOME="$SHARNESS_TRASH_DIRECTORY"
TEMP_DIR="$SHARNESS_TEST_DIRECTORY/temp"
#rm -rf $TEMP_DIR
export HOME="$TEMP_DIR"
unset  DSDIR
export DSDIR="$HOME"/.ds

mkdir -p $DSDIR
cat <<_EOF > $DSDIR/config.sh
GITHUB=https://github.com/docker-scripts
APPS=$TEMP_DIR/docker-scripts
CONTAINERS=$TEMP_DIR/containers
_EOF
