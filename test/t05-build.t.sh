description 'Test ds build'

test_case 'ds init ds/test/app1 @test1' '
    ds pull ds &&
    rm -rf $CONTAINERS/test1 &&
    ds init ds/test/app1 @test1
'

test_case 'ds @test1 build' '
    ds @test1 build &&
    tail $CONTAINERS/test1/logs/ds-test-app1-*.out | grep "Successfully built" &&
    docker images --format "{{.Repository}}" | grep ds-test-app1
'

test_case 'ds build' '
    cd $CONTAINERS/test1 &&
    ds build &&
    tail logs/ds-test-app1-*.out | grep "Successfully built"
'
