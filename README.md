DockerScripts
=============

This is a shell script framework for Docker which simplifies managing
containers in a context. Each container is like a virtual machine that
has an application installed inside. Each container has a base
directory where the settings of the container are stored (in the file
*settings.sh*). The command `ds` picks the parameters that it needs
from the file *settings.sh* in the current directory.

## COMMANDS

* `init` *<src_dir>*, `info`

    Initialize a working directory by getting the file *settings.sh*
    from the given source directory. Show some of the current
    settings.

* `build`, `create`, `config`

    Build the image, create the container, and configure the guest
    system inside the container.

* `start`, `stop`, `restart`

    Start, stop and restart the container.

* `shell`

    Get a shell on the container.

* `exec`

    Execute a command inside the container.

* `snapshot`

    Make a snapshot of the container.

* `remove`

    Remove the container and the image.

* `help`

    Display a help message.



## FILES

   `./settings.sh`
          It is located in directory of the container and keeps
          the settings of the container and the application installed
          inside it.


## CUSTOMIZATION

The file `$SRC/ds.sh` or `./ds.sh` can be used to redefine and
customize some functions, without having to touch the code of the main
script.  Also, custom commands can be defined for each container by
adding the file `./cmd/command.sh`, which contains the function
`cmd_command() { . . . }`.


## INSTALLATION

   git clone https://github.com/docker-scripts/ds
   cd ds/
   sudo make install
   ds help


## USAGE

   Some examples of using `ds` are shown below.

### Installing Moodle

    git clone https://github.com/docker-scripts/moodle /usr/local/src/moodle
    mkdir -p /var/containers/moodle1
    cd /var/containers/moodle1/
    ds init /usr/local/src/moodle
    vim settings.sh
    ds build
    ds create
    ds config
    ds shell
