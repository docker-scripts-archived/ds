# completion file for bash
# for help see:
#  - http://tldp.org/LDP/abs/html/tabexpansion.html
#  - https://www.debian-administration.org/article/317/An_introduction_to_bash_completion_part_2
#  - https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

_ds()
{
    COMPREPLY=()   # Array variable storing the possible completions.
    local cur=${COMP_WORDS[COMP_CWORD]}     ## $2
    local prev=${COMP_WORDS[COMP_CWORD-1]}  ## $3
    local preprev=${COMP_WORDS[COMP_CWORD-2]}

    [[ "$preprev" == '@' ]] && COMPREPLY=( $(compgen -W "$(_ds_commands)" -- $cur) ) && return

    case $prev in
        ds|docker.sh|sh/docker.sh)
            case $cur in
                -*) COMPREPLY=( $(compgen -W "-x -v --version -h --help" -- $cur) )
                    ;;
                @)  COMPREPLY=( $(compgen -W "$(_ds_containers)" -- $cur) )
                    ;;
                *)  COMPREPLY=( $(compgen -W "$(_ds_commands)" -- $cur) )
                    ;;
            esac
            ;;
        -x)
            case $cur in
                @)  COMPREPLY=( $(compgen -W "$(_ds_containers)" -- $cur) )
                    ;;
                *)  COMPREPLY=( $(compgen -W "$(_ds_commands)" -- $cur) )
                    ;;
            esac
            ;;
        @)  COMPREPLY=( $(compgen -W "$(_ds_containers)" -- "@$cur") )
            ;;
        init)
            COMPREPLY=( $(compgen -W "$(_ds_apps)" -- $cur) )
            ;;
        runcfg)
            local cfgscripts="apache2 get-ssl-cert mount_tmp_on_ram mysql phpmyadmin set_prompt ssmtp"
            cfgscripts+=" $(_ds_custom_cfgscripts)"
            COMPREPLY=( $(compgen -W "$cfgscripts" -- $cur) )
            ;;
        *)  _ds_custom_completion $prev $cur
            ;;
    esac
}

_ds_get_var() {
    local var=$1
    local file=$2
    cat $file | grep "${var}=" | sed -e "s/${var}=//" | tr -d "'"'"'' '
}

_ds_container_dir() {
    local CONTAINERS=$(_ds_get_var CONTAINERS ${DSDIR:-$HOME/.ds}/config.sh)
    local container_dir='.'
    [[ "${COMP_WORDS[1]}" == '@' ]] && [[ $COMP_CWORD -gt 1 ]] && container_dir="$CONTAINERS/${COMP_WORDS[2]}"
    [[ "${COMP_WORDS[2]}" == '@' ]] && [[ $COMP_CWORD -gt 2 ]] && container_dir="$CONTAINERS/${COMP_WORDS[3]}"
    echo "$container_dir"
}

_ds_app_dir() {
    local APPS=$(_ds_get_var APPS ${DSDIR:-$HOME/.ds}/config.sh)
    local APP=$(_ds_get_var APP $(_ds_container_dir)/settings.sh)
    echo "$APPS/$APP"
}

_ds_commands() {
    local commands="version start stop restart shell exec remove"
    commands+=" build config create help info init runcfg snapshot"
    commands+=" $(_ds_custom_commands)"
    echo $commands
}

_ds_custom_commands() {
    local commands=""
    local appdir=$(_ds_app_dir)
    [[ -d $appdir/cmd/ ]] && commands=$(ls $appdir/cmd/)
    commands="${commands//.sh/}"
    echo $commands
}

_ds_apps() {
    local APPS=$(_ds_get_var APPS ${DSDIR:-$HOME/.ds}/config.sh)
    [[ -n $APPS ]] || return
    local apps=$(ls $APPS)
    echo $apps
}

_ds_containers() {
    local CONTAINERS=$(_ds_get_var CONTAINERS ${DSDIR:-$HOME/.ds}/config.sh)
    [[ -n $CONTAINERS ]] || return
    local containers=$(ls $CONTAINERS)
    containers=$(echo $containers | sed -e 's/ / @/g')
    [[ -n "$containers" ]] && containers="@$containers"
    echo $containers
}

_ds_custom_cfgscripts() {
    local cfgscripts=""
    [[ -d $(_ds_app_dir)/config/ ]] && cfgscripts=$(ls $(_ds_app_dir)/config/)
    cfgscripts="${cfgscripts//.sh/}"
    echo $cfgscripts
}

_ds_custom_completion() {
    # check that the function with the given name exists
    _ds_function_exists() {
        declare -Ff "$1" >/dev/null
        return $?
    }

    local prev=$1
    local cur=$2
    local cmd=$prev

    local file=$(_ds_app_dir)/bash-completion.sh
    [[ -f $file ]] && source $file || return
    _ds_function_exists "_ds_$cmd" && _ds_$cmd "$cur" "$prev"
}

complete -F _ds ds docker.sh sh/docker.sh
