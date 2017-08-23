# Auxiliary functions.

fail() {
    echo -e "$@" >&2
    exit 1
}

# Change the name of an existing function.
# Useful when redefining standard commands.
rename_function() {
  test -n "$(declare -f $1)" &&
  eval "${_/$1/$2}" &&
  unset -f "$1";
}

# Test whether the given name is a function.
is_function() {
    declare -Ff "$1" >/dev/null
    return $?
}

# Check whether a container is up.
is_up() {
    local container=${1:-$CONTAINER}
    docker ps | grep $container >/dev/null
    return $?
}

# run the given command and log its output
log() {
    local datestamp=$(date +%F | tr -d -)
    local logfile=logs/$CONTAINER-$datestamp.out
    mkdir -p logs/
    cat << _EOF >> $logfile

################################################################################
###    Time: $(date)
### Command: $*
################################################################################

_EOF
    $* 2>&1 | tee -a $logfile
}
