description 'Test remove'

ds pull ds
ds @test1 stop
rm -rf $CONTAINERS/test1
ds @test2 stop
rm -rf $CONTAINERS/test2

test_case 'ds @test1 create' '
    ds init ds/test/app1 @test1 &&
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start
'

test_case 'ds @test2 create' '
    ds init ds/test/app2 @test2 &&
    ds @test2 build &&
    ds @test2 create &&
    ds @test2 start
'

test_case 'ds @test1 remove' '
    ds @test1 remove &&
    [[ -z "$(docker ps -a --format "{{.Names}}" | grep ds-test-app1)" ]] &&
    [[ -z "$(docker images --format "{{.Repository}}" | grep ds-test-app1)" ]]
'

test_case 'ds @test2 remove' '
    ds @test2 remove &&
    test ! -f $DSDIR/cmd/test2.sh
'

# cleanup
#rm -rf "$HOME"
