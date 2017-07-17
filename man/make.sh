#!/bin/bash

cd $(dirname $0)
export RONN_STYLE="$(pwd)"
ronn --manual="DockerScripts" \
     --organization="dashohoxha" \
     --style="toc,80c,dark" \
     ds.1.ronn
