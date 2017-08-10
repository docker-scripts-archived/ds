#!/bin/bash -x

source /host/settings.sh

cat <<EOF > /etc/test1.sh
APP=$APP
IMAGE=$IMAGE
CONTAINER=$CONTAINER
DOMAIN=$DOMAIN
EOF
