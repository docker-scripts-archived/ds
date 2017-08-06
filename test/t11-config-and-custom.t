#!/usr/bin/env bash

test_description='Test configuration, overriding commands, adding new commands, etc.'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds @test2 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test2 &&
    ds init ds/test/app2 @test2
    ds @test2 build &&
    ds @test2 create
'

test_expect_success 'ds @test2 start,stop,restart (overriden commands)' '
    ds @test2 stop &&
    ds @test2 start | grep "Starting container" &&
    ds @test2 stop | grep "Stoping container" &&
    ds @test2 restart | grep "Restarting container"
'

test_expect_success 'ds @test2 config (run configuration scripts)' '
    ds @test2 config | grep "Running configuration script"
'

test_expect_success 'ds @test2 runcfg test1 (config script "test1")' '
    ds @test2 exec rm -f /etc/test1.sh &&
    ds @test2 runcfg test1 &&
    ds @test2 exec cat /etc/test1.sh | grep CONTAINER
'

test_expect_success 'ds @test2 runcfg site [enable|disable] (config script "site")' '
    ds @test2 runcfg site | grep "Usage" &&
    ds @test2 runcfg site disable &&
    ds @test2 exec test ! -f /etc/apache2/sites-enabled/$IMAGE.conf &&
    ds @test2 runcfg site enable &&
    ds @test2 exec test ! -f /etc/apache2/sites-enabled/$IMAGE.conf
'

test_expect_success 'ds @test2 apache2 [start|stop] (new command apache2)' '
    ds @test2 apache2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]] &&
    ds @test2 apache2 stop &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) == 0 ]] &&
    ds @test2 apache2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]]
'

test_expect_success 'ds @test1 test2 [start|stop] (new global command test2)' '
    ds @test1 help | grep "test2" &&
    ds @test1 test2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]] &&
    ds @test1 test2 stop &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) == 0 ]] &&
    ds @test1 test2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]]
'

test_done

