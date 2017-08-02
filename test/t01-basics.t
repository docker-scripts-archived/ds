#!/usr/bin/env bash

test_description='Basic checks'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds' '
    [[ "$(ds | grep APPS)" == "APPS=$APPS" ]]
'

test_expect_success 'ds -v ; ds --version' '
    ds -v | grep DockerScript &&
    ds --version | grep DockerScript
'

test_expect_success 'ds -h ; ds --help' '
    ds -h | grep "The commands are listed below" &&
    ds --help | grep "The commands are listed below"
'

test_done
