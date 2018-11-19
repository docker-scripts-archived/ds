#!/bin/bash -x

source /host/settings.sh

if [[ -n $GMAIL_ADDRESS ]]; then
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
elif [[ -n $SMTP_SERVER ]]; then
    cat <<-_EOF > /etc/ssmtp/ssmtp.conf
mailhub=$SMTP_SERVER
rewriteDomain=${SMTP_DOMAIN:-$DOMAIN}
UseSTARTTLS=YES
FromLineOverride=YES
_EOF
fi
