cmd_help_help() {
    cat <<_EOF
    help
        Display a help message.

_EOF
}

cmd_help() {
    cat <<-_EOF

Usage: $PROGRAM [-x] [@<container>] <command> [<arg>...]

DockerScripts is a shell script framework for Docker.

Each container is like a virtual machine that has an application
installed inside. Each container has a base directory where the
settings of the container are stored (in the file
'settings.sh'). The command 'ds' picks the parameters that it needs
from the file 'settings.sh' in the container's directory.

Normally the commands are issued from inside the container's
directory, however the option '@<container>' can be used to specify
the context of the command.

The option '-x' can be used for debugging.

The commands are listed below:

    pull <app> [<branch>]
        Clone or pull '$GITHUB/<app>'
        to '$APPS/<app>'. A certain branch can be specified
        as well. When a branch is given, then it is saved to
        '$APPS/<app>-<branch>'.

    init <app> [@<container>]
        Initialize a container directory by getting the file 'settings.sh'
        from the given app directory. If the second argument is missing,
        the current directory will be used to initialize the container,
        otherwise it will be done on '$CONTAINERS/<container>'.

    info
        Show some info about the container of the current directory.

    build, create, config
        Build the image, create the container, and configure
        the guest system inside the container.

    inject [<script>]
        Inject and run a script inside the container.

    start, stop, restart
        Start, stop and restart the container.

    shell, exec
        Get a shell on the container, or execute a command from outside.

    snapshot
        Make a snapshot of the container.

    remove
        Remove the container and the image.

    runtest [-d|--debug] [<test-script.t.sh>...]
        Run the given test scripts. If no test-script is given
        all the test scripts in the working directory will be run.
        Test scripts have the extension '.t.sh'

    test [-d|--debug] [<test-script.t.sh>...]
        Run the given test scripts inside the ds-test container.
        It actually call the command 'runtest' inside the container
        with the same options and arguments.

    help
        Display a help message.

More information may be found in the ds(1) man page.

_EOF

    local cmd cmd_help
    for cmd_file in $APP_DIR/cmd/*.sh $DSDIR/cmd/*.sh ./cmd/*.sh; do
        [[ -f "$cmd_file" ]] || continue
        source "$cmd_file"
        cmd=$(basename "${cmd_file%%.sh}")
        cmd_help=cmd_${cmd}_help
        is_function $cmd_help && $cmd_help || echo -e "    $cmd\n"
    done
}
