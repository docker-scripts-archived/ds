#!/bin/bash -x
### install openssh

DEBIAN_FRONTEND=noninteractive \
    apt -y install openssh-server openssh-client

sshd_port=${$1:-22}

### customize the configuration of sshd
sed -i /etc/ssh/sshd_config \
    -e 's/^Port/#Port/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/'

sed -i /etc/ssh/sshd_config \
    -e '/^### custom config/,$ d'

cat <<EOF >> /etc/ssh/sshd_config
### custom config
Port $sshd_port
PasswordAuthentication no
X11Forwarding no
EOF
