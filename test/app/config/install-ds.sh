#!/bin/bash -x
DS_APP_DIR=${1:-/opt/docker-scripts/ds}
cd $DS_APP_DIR
make install
