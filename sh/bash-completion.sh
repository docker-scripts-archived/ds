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

    [[ "$preprev" == '@' ]] && _ds_commands $cur && return

    case $prev in
        ds)
            case $cur in
                -*) COMPREPLY=( $(compgen -W "-x -v --version -h --help" -- $cur) ) ;;
                @)  _ds_containers $cur ;;
                *)  _ds_commands $cur ;;
            esac
            ;;
        -x)
            case $cur in
                @)  _ds_containers $cur ;;
                *)  _ds_commands $cur ;;
            esac
            ;;
        @)
            _ds_containers "@$cur"
            ;;
        init)
            _ds_cmd_init $cur
            ;;
        inject)
            _ds_cmd_inject $cur
            ;;
        runtest|test)
            COMPREPLY=( $(compgen -f -X '!*.t.sh' -- $cur) )
            ;;
        *)
            _ds_custom_completion "$prev" "$cur"
            ;;
    esac
}

_ds_commands() {
    local commands="version start stop restart shell exec remove"

    local cmdlist=''
    for dir in \
        /usr/lib/ds \
        $(_ds_app_dir) \
        ${DSDIR:-$HOME/.ds} \
        $(_ds_container_dir)
    do
        [[ -d $dir/cmd/ ]] && cmdlist+=" $(ls $dir/cmd/)"
    done

    commands+=" ${cmdlist//.sh/}"
    COMPREPLY=( $(compgen -W "$commands" -- $1) )
}

_ds_containers() {
    local cur=$1
    local containers=''
    if [[ "${cur:1:1}" == '/' || "${cur:1:2}" == './' ]]; then
        compopt -o nospace
        containers=$(compgen -o dirnames -- ${cur:1})
    else
        local CONTAINERS=$(_ds_get_var CONTAINERS ${DSDIR:-$HOME/.ds}/config.sh)
        [[ -n $CONTAINERS ]] || return
        containers=$(ls $CONTAINERS)
    fi
    containers=$(echo $containers | sed -e 's/ / @/g')
    [[ -n "$containers" ]] && containers="@$containers"
    COMPREPLY=( $(compgen -W "$containers" -- $cur) )
}

_ds_cmd_init() {
    #compopt -o plusdirs
    local APPS=$(_ds_get_var APPS ${DSDIR:-$HOME/.ds}/config.sh)
    [[ -n $APPS ]] || return
    COMPREPLY=( $(compgen -W "$(ls $APPS)" -- $1) )
}

_ds_cmd_inject() {
    local scripts=''
    for dir in \
        /usr/lib/ds \
        $(_ds_app_dir) \
        ${DSDIR:-$HOME/.ds} \
        $(_ds_container_dir)
    do
        [[ -d $dir/scripts/ ]] && scripts+=" $(ls $dir/scripts/)"
    done

    COMPREPLY=( $(compgen -W "$scripts" -- $1) )
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

# --------------------------------------------

_ds_get_var() {
    local var=$1
    local file=$2
    [[ -f $file ]] || return
    cat $file | grep "${var}=" | sed -e "s/${var}=//" | tr -d "'"'"'' '
}

_ds_app_dir() {
    local container_dir=$(_ds_container_dir)
    local APP=$(_ds_get_var APP $container_dir/settings.sh)
    [[ "${APP:0:1}" == '/' ]]  && echo "$APP" && return
    [[ -d "$container_dir/$APP" ]] && echo "$container_dir/$APP" && return
    local APPS=$(_ds_get_var APPS ${DSDIR:-$HOME/.ds}/config.sh)
    [[ -d "$APPS/$APP" ]] && echo "$APPS/$APP" && return
}

_ds_container_dir() {
    local CONTAINERS=$(_ds_get_var CONTAINERS ${DSDIR:-$HOME/.ds}/config.sh)
    local dir='.'
    if [[ "${COMP_WORDS[1]}" == '@' && $COMP_CWORD -gt 1 ]]; then
        dir="$CONTAINERS/${COMP_WORDS[2]}"
        [[ -d "$dir" ]] || dir="${COMP_WORDS[2]}"
    fi
    if [[ "${COMP_WORDS[2]}" == '@' && $COMP_CWORD -gt 2 ]]; then
        dir="$CONTAINERS/${COMP_WORDS[3]}"
        [[ -d "$dir" ]] || dir="${COMP_WORDS[3]}"
    fi
    echo "$dir"
}

# --------------------------------------------

complete -F _ds ds
