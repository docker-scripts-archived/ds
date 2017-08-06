#!/usr/bin/env bash

test_description='Test remove'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds @test1 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start
'

test_expect_success 'ds @test2 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test2 &&
    ds init ds/test/app2 @test2
    ds @test2 build &&
    ds @test2 create &&
    ds @test2 config
'

test_expect_success 'ds @test1 remove' '
    ds @test1 remove &&
    [[ -z "$(docker ps -a --format "{{.Names}}" | grep ds-test-app1)" ]] &&
    [[ -z "$(docker images --format "{{.Repository}}" | grep ds-test-app1)" ]]
'

test_expect_success 'ds @test2 remove' '
    ds @test2 remove &&
    test ! -f $DSDIR/cmd/test2.sh
'

# cleanup
rm -rf "$TEMP_DIR"

test_done
