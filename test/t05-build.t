#!/usr/bin/env bash

test_description='Test: ds build'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds @test1 build' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1 &&
    ds @test1 build &&
    tail $CONTAINERS/test1/nohup-*.out | grep "Successfully built" &&
    docker images --format "{{.Repository}}" | grep ds-test-app1
'

test_expect_success 'ds build' '
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1 &&
    cd $CONTAINERS/test1 &&
    ds build &&
    tail nohup-*.out | grep "Successfully built"
'

test_done
