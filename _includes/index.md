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
