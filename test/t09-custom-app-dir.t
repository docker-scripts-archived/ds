#!/usr/bin/env bash

test_description='Test custom dirs'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds init ds/test/app1 @test1' '
    rm -rf $CONTAINERS/test1 &&
    git clone https://github.com/docker-scripts/ds $TEMP_DIR/ds &&
    ds init $TEMP_DIR/ds/test/app1 @test1 &&
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start &&
    ds @test1 remove
'

test_done
