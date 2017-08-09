description 'Test custom dirs'

test_case 'ds init custom_dir/ds/test/app1 @test1' '
    rm -rf $CONTAINERS/test1 &&
    rm -rf $HOME/ds &&
    git clone https://github.com/docker-scripts/ds $HOME/ds &&
    ds init $HOME/ds/test/app1 @test1 &&
    ds @test1 build &&
    ds @test1 create &&
    ds @test1 start
'

test_case 'ds init ds/test/app1 @custom_dir' '
    rm -rf $HOME/test1 &&
    ds pull ds &&
    ds init ds/test/app1 @$HOME/test1 &&
    ds @$HOME/test1 build &&
    cd $HOME/test1 &&
    ds create &&
    ds start
'
