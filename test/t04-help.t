#!/usr/bin/env bash

test_description='Test: ds help'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds help' '
    ds help 2>&1 | grep "No file ./settings.sh found."
'

test_expect_success 'ds @wsproxy help' '
    ds pull wsproxy &&
    rm -rf $CONTAINERS/wsproxy &&
    ds init wsproxy @wsproxy &&
    ds @wsproxy help | grep "DockerScripts is a shell script framework for Docker."
'

test_expect_success 'ds help' '
    cd $CONTAINERS/wsproxy &&
    local helpmsg="$(ds help)" &&
    echo "$helpmsg" | grep "DockerScripts is a shell script framework for Docker." &&
    echo "$helpmsg" | grep "domains-add" &&
    echo "$helpmsg" | grep "get-ssl-cert"
'

test_expect_success 'ds -x help' '
    cd $CONTAINERS/wsproxy &&
    [[ "$(ds -x help 2>&1 | grep + | wc -l)" -gt 100 ]] &&
    [[ "$(ds -x @wsproxy help 2>&1 | grep + | wc -l)" -gt 100 ]]
    ds @wsproxy -x help 2>&1 | grep "Cannot find command"
'

test_done
