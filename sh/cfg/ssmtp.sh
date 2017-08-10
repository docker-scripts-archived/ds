#!/bin/bash -x

source /host/settings.sh

[[ -z $GMAIL_ADDRESS ]] && exit 0

### modify ssmtp config files
cat <<-_EOF > /etc/ssmtp/ssmtp.conf
root=$GMAIL_ADDRESS
mailhub=smtp.gmail.com:587
AuthUser=$GMAIL_ADDRESS
AuthPass=$GMAIL_PASSWD
UseTLS=YES
UseSTARTTLS=YES
rewriteDomain=gmail.com
hostname=localhost
FromLineOverride=YES
_EOF
cat <<-_EOF > /etc/ssmtp/revaliases
root:$GMAIL_ADDRESS:smtp.gmail.com:587
_EOF
