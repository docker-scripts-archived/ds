#!/usr/bin/env bash

test_description='Test custom dirs'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds init custom_dir/ds/test/app1 @test1' '
    rm -rf $CONTAINERS/test1 &&
    rm -rf $TEMP_DIR/ds &&
    git clone https://github.com/docker-scripts/ds $TEMP_DIR/ds &&
    ds init $TEMP_DIR/ds/test/app1 @test1 &&
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start
'

test_expect_success 'ds init ds/test/app1 @custom_dir' '
    rm -rf $TEMP_DIR/test1 &&
    ds pull ds &&
    ds init ds/test/app1 @$TEMP_DIR/test1 &&
    ds @$TEMP_DIR/test1 build &&
    cd $TEMP_DIR/test1 &&
    ds create &&
    ds start
'

test_done
