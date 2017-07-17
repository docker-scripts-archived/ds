cmd_help() {
    cat <<-_EOF

Usage: $PROGRAM <command>

DockerScripts is a shell script wrapper around Docker
which simplifies managing containers in a context.
The commands are listed below.

    init <src_dir>, info
        Initialize a working directory by getting the file 'settings.sh'
        from the given source directory. Show some of the current settings

    build, create, config
        Build the image, create the container, and configure
        the guest system inside the container.

    start, stop, restart
        Start, stop and restart the container.

    shell, exec
        Get a shell on the container, or execute a command from outside.

    snapshot
        Make a snapshot of the container.

    remove
        Remove the container and the image.

    help
        Display a help message.
_EOF

    for cmd_file in $SRC/cmd/*.sh; do
        [[ -f "$cmd_file" ]] || continue
        source "$cmd_file"
        cmd=$(basename "${cmd_file%%.sh}")
        cmd_${cmd}_help
    done

    cat <<_EOF

More information may be found in the ds(1) man page.

_EOF

}
