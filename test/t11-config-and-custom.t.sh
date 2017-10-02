description 'Test configuration, overriding commands, adding new commands, etc.'

test_case 'ds @test2 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test2 &&
    ds init ds/test/app2 @test2
    ds @test2 build &&
    ds @test2 create
'

test_case 'ds @test2 start,stop,restart (overriden commands)' '
    ds @test2 stop &&
    ds @test2 start | grep "Starting container" &&
    ds @test2 stop | grep "Stoping container" &&
    ds @test2 restart | grep "Restarting container"
'

test_case 'ds @test2 config (run configuration scripts)' '
    ds @test2 config | grep "Running script"
'

test_case 'ds @test2 inject test1.sh (config script "test1")' '
    ds @test2 exec rm -f /etc/test1.sh &&
    ds @test2 inject test1.sh &&
    ds @test2 exec cat /etc/test1.sh | grep CONTAINER
'

test_case 'ds @test2 inject site.sh [enable|disable] (config script "site")' '
    ds @test2 inject site.sh | grep "Usage" &&
    ds @test2 inject site.sh disable &&
    ds @test2 exec test ! -f /etc/apache2/sites-enabled/default.conf &&
    ds @test2 inject site.sh enable &&
    ds @test2 exec test -f /etc/apache2/sites-enabled/default.conf
'

test_case 'ds @test2 apache2 [start|stop] (new command apache2)' '
    ds @test2 apache2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]] &&
    ds @test2 apache2 stop &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) == 0 ]] &&
    ds @test2 apache2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]]
'

test_case 'ds @test1 create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
    ds @test1 build &&
    ds @test1 create
'

test_case 'ds @test1 test2 [start|stop] (new global command test2)' '
    ds @test1 help | grep "test2" &&
    ds @test1 test2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]] &&
    ds @test1 test2 stop &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) == 0 ]] &&
    ds @test1 test2 start &&
    [[ $(ds @test2 exec ps ax | grep -v grep | grep apache2 -c) > 0 ]]
'

