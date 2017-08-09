description 'Test ds init'

test_case 'ds init ds/test/app1 @test1' '
    rm -rf $CONTAINERS/test1 &&
    ds pull ds &&
    ds init ds/test/app1 @test1 &&
    [[ -d $CONTAINERS/test1 ]] &&
    [[ -f $CONTAINERS/test1/settings.sh ]]
'

test_case 'ds init ds/test/app1' '
    rm -rf $CONTAINERS/test1 &&
    mkdir -p  $CONTAINERS/test1 &&
    cd $CONTAINERS/test1 &&
    ds init ds/test/app1 &&
    [[ -f $CONTAINERS/test1/settings.sh ]]
'

test_case 'ds init (already exists)' '
    [[ -f $CONTAINERS/test1/settings.sh ]] &&
    cd $CONTAINERS/test1 &&
    ds init ds/test/app1 2>&1 | grep "already exists" &&
    ds init ds/test/app1 @test1 2>&1 | grep "already exists"
'

test_case 'ds init (wrong params)' '
    rm -rf $CONTAINERS/test1 &&
    mkdir -p $APPS/test1 &&
    ds init 2>&1 | grep "Usage:" &&
    ds init ds1 2>&1 | grep "Cannot find the directory of" &&
    ds init ds/test/app1 test11 2>&1 | grep "Usage:" &&
    ds init ds/test @test1 2>&1 | grep "There is no file"
'
