#!/bin/bash

APPS=${1:-/opt/docker-scripts}
cd $APPS/ds/
make
