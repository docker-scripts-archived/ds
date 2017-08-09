description 'Basic checks'

test_case 'ds' '
    [[ "$(ds | grep APPS)" == "APPS=$APPS" ]]
'

test_case 'ds -v ; ds --version' '
    ds -v | grep DockerScript &&
    ds --version | grep DockerScript
'

test_case 'ds -h ; ds --help' '
    ds -h | grep "The commands are listed below" &&
    ds --help | grep "The commands are listed below"
'

