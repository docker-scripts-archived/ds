#!/bin/bash -x
### Run tests inside a docker container.

ulimit=$(ulimit -n)
ulimit -n 9000

DSDIR=${DSDIR:-$HOME/.ds}
source $DSDIR/config.sh

ds pull ds
cd $APPS/ds/test
ds init ds/test/app @ds-test
cd $CONTAINERS/ds-test

ds build
ds create
ds config

ds runcfg make $APPS
ds exec $APPS/ds/test/run.sh "$@"

ulimit -n $ulimit
