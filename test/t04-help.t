#!/usr/bin/env bash

test_description='Test: ds help'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds help' '
    ds help 2>&1 | grep "No file ./settings.sh found."
'

test_expect_success 'ds @test2 help' '
    ds pull ds &&
    rm -rf $CONTAINERS/test2 &&
    ds init ds/test/app2 @test2 &&
    ds @test2 help | grep "DockerScripts is a shell script framework for Docker."
'

test_expect_success 'ds help' '
    cd $CONTAINERS/test2 &&
    local helpmsg="$(ds help)" &&
    echo "$helpmsg" | grep "DockerScripts is a shell script framework for Docker." &&
    echo "$helpmsg" | grep "apache2" &&
    echo "$helpmsg" | grep "test2"
'

test_expect_success 'ds -x help' '
    cd $CONTAINERS/test2 &&
    [[ "$(ds -x help 2>&1 | grep + | wc -l)" -gt 100 ]] &&
    [[ "$(ds -x @test2 help 2>&1 | grep + | wc -l)" -gt 30 ]] &&
    [[ "$(ds @test2 -x help 2>&1 | grep + | wc -l)" -gt 100 ]]
'

test_done
