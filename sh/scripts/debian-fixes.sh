#!/bin/bash -x
### customize a bit the standard debian container

source /host/settings.sh

echo $CONTAINER > /etc/debian_chroot

cat << 'EOF' >> /root/.bashrc

# make ls colorized
export LS_OPTIONS='--color=auto'
export SHELL='/bin/bash'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# set a custom prompt
PS1='\n\[\033[01;32m\]${debian_chroot:+$debian_chroot }\[\033[00m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\e[32m\]\n==> \$ \[\033[00m\]'

EOF
