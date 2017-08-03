#!/usr/bin/env bash

test_description='Test info and snapshot'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start &&
    docker ps --format "{{.Names}}" | grep ds-test-app1
'

test_expect_success 'ds @test1 info' '
    local output="$(ds @test1 info)" &&
    echo "$output" | grep SETTINGS &&
    echo "$output" | grep IMAGE &&
    echo "$output" | grep CONTAINER
'

test_expect_success 'ds @test1 snapshot' '
    local snapshot="ds-test-app1:$(date +%F)" &&
    ds @test1 snapshot | grep "Making a snapshot of ds-test-app1 to $snapshot" &&
    ds @test1 info | grep $snapshot &&
    docker rmi $snapshot
'

test_done
