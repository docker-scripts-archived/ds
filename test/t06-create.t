#!/usr/bin/env bash

test_description='Test create and remove'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds init ds/test/app1 @test1' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
'

test_expect_success 'ds @test1 build' '
    ds @test1 build &&
    docker images --format "{{.Repository}}" | grep ds-test-app1
'

test_expect_success 'ds @test1 create' '
    ds @test1 create &&
    docker ps -a --format "{{.Names}}" | grep ds-test-app1
'

test_expect_success 'ds @test1 remove' '
    ds @test1 remove &&
    [[ -z "$(docker ps -a --format "{{.Names}}" | grep ds-test-app1)" ]] &&
    [[ -z "$(docker images --format "{{.Repository}}" | grep ds-test-app1)" ]]
'

test_done
