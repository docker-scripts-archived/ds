# Initialize a working directory.

cmd_init_help() {
    cat <<_EOF
    init <src_dir>
        Initialize a working directory by getting the file 'settings.sh'
        from the given source directory.
_EOF
}

cmd_init() {
    [[ -f settings.sh ]] \
        && fail "There is already a file 'settings.sh' on this directory.\nInitialization failed."
    local src_dir="$1" ; shift
    [[ -n "$src_dir" ]] || fail "Usage:\n$(cmd_init_help)"
    [[ -d "$src_dir" ]] || fail "Cannot find directory '$src_dir'"
    [[ -f "$src_dir"/settings.sh ]] || fail "There is no file 'settings.sh' on '$src_dir'"

    # copy and update settings
    cp "$src_dir"/settings.sh .
    sed -i settings.sh -e "/^SRC=/ c SRC='$src_dir'"
}
