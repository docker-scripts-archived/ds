#!/usr/bin/env bash

test_description='Test remove'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds @test2 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test2 &&
    ds init ds/test/app2 @test2
    ds @test2 build &&
    ds @test2 create
'

test_expect_success 'ds @test2 start,stop,restart (customized)' '
    ds @test2 stop &&
    ds @test2 start | grep "Starting container" &&
    ds @test2 stop | grep "Stoping container" &&
    ds @test2 restart | grep "Restarting container"
'

test_expect_success 'ds @test2 config' '
    ds @test2 config | grep "Running configuration script"
'

test_expect_success 'ds @test2 runcfg test1' '
    ds @test2 exec rm -f /etc/test1.sh &&
    ds @test2 runcfg test1 &&
    ds @test2 exec cat /etc/test1.sh | grep CONTAINER
'

test_expect_success 'ds @test2 runcfg site [enable|disable]' '
    ds @test2 runcfg site | grep "Usage" &&
    ds @test2 runcfg site disable &&
    ds @test2 exec test ! -f /etc/apache2/sites-enabled/$IMAGE.conf &&
    ds @test2 runcfg site enable &&
    ds @test2 exec test ! -f /etc/apache2/sites-enabled/$IMAGE.conf
'

test_done
