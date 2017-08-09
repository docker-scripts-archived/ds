description 'Test ds start'

test_case 'ds create' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
    ds @test1 build &&
    ds @test1 create &&
    docker ps -a --format "{{.Names}}" | grep ds-test-app1
'

test_case 'ds @test1 start' '
    ds @test1 start &&
    docker ps --format "{{.Names}}" | grep ds-test-app1
'

test_case 'ds @test1 stop' '
    ds @test1 stop &&
    [[ -z $(docker ps --format "{{.Names}}" | grep ds-test-app1) ]]
'

test_case 'ds start' '
    cd $CONTAINERS/test1 &&
    ds start &&
    docker ps --format "{{.Names}}" | grep ds-test-app1
'

test_case 'ds stop' '
    ds stop &&
    [[ -z $(docker ps --format "{{.Names}}" | grep ds-test-app1) ]]
'

test_case 'ds restart' '
    ds restart &&
    docker ps --format "{{.Names}}" | grep ds-test-app1
'
