# completion file for bash
# for help see:
#  - http://tldp.org/LDP/abs/html/tabexpansion.html
#  - https://www.debian-administration.org/article/317/An_introduction_to_bash_completion_part_2
#  - https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

_ds()
{
    COMPREPLY=()   # Array variable storing the possible completions.
    local cur=${COMP_WORDS[COMP_CWORD]}
    local commands="init info build create config shell exec start stop restart snapshot remove help version"
    COMPREPLY=( $(compgen -W "$commands" -- $cur) )
}

complete -F _ds ds docker.sh src/docker.sh
