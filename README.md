DockerScripts
=============

## SYNOPSIS

   `ds [-x] [@<container>] <command> [<arg>...]`


## DESCRIPTION

   DockerScripts is a shell script framework for Docker.

   Each container is like a virtual machine that has an application
   installed inside. Each container has a base directory where the
   settings of the container are stored (in the file
   `settings.sh`). The command `ds` picks the parameters that it needs
   from the file `settings.sh` in the container's directory.

   Normally the commands are issued from inside the container's
   directory, however the option `@<container>` can be used to specify
   the context of the command.

   The option `-x` can be used for debugging.


## INSTALLATION

    git clone https://github.com/docker-scripts/ds /opt/docker-scripts/ds
    cd /opt/docker-scripts/ds/
    make install
    ds
    ds -h


## EXAMPLES

### Installing Web Server Proxy

    ds pull wsproxy
    ds init wsproxy @wsproxy
    source ds cd @wsproxy   # (or: cd /var/ds/wsproxy/)
    vim settings.sh
    ds build
    ds create
    ds config


### Installing Moodle

    ds pull moodle
    ds init moodle @moodle1

    source ds cd @moodle1   # (or: cd /var/ds/moodle1/)
    vim settings.sh
    ds build
    ds create
    ds config

    ds @wsproxy domains-add moodle1-example-org moodle1.example.org
    ds @wsproxy get-ssl-cert user@example.org moodle1.example.org --test
    ds @wsproxy get-ssl-cert user@example.org moodle1.example.org


### Installing ShellInABox

    ds pull shellinabox
    ds init shellinabox @shell1

    source cd ds @shell1
    vim settings.sh
    ds build
    ds create
    ds config

    source cd ds @wsproxy
    ds domains-add shell1-example-org shell1.example.org
    ds get-ssl-cert user@example.org shell1.example.org --test
    ds get-ssl-cert user@example.org shell1.example.org


## COMMANDS

* `pull <app> [<branch>]`

    Clone or pull `https://github.com/docker-scripts/<app>` to
    `/opt/docker-scripts/<app>`. A certain branch can be specified
    as well. When a branch is given, then it is saved to
    `/opt/docker-scripts/<app>-<branch>`.

* `init <app> [@<container>]`

    Initialize a container directory by getting the file `settings.sh`
    from the given app directory. If the second argument is missing,
    the current directory will be used to initialize the container,
    otherwise it will be done on `/var/ds/<container>`.

* `info`

    Show some info about the container of the current directory.

* `build`, `create`, `config`

    Build the image, create the container, and configure the guest
    system inside the container.

* `runcfg <cfg>`

    Run a configuration script inside the container.

* `start`, `stop`, `restart`

    Start, stop and restart the container.

* `shell`

    Get a shell on the container.

* `exec`

    Execute a command from outside the container.

* `snapshot`

    Make a snapshot of the container.

* `remove`

    Remove the container and the image.

* `help`

    Display a help message.


