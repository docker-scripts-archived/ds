#!/bin/bash -x

### regenerate the password of debian-sys-maint
passwd=$(mcookie | head -c 16)
mysql --defaults-file=/etc/mysql/debian.cnf -B \
    -e "SET PASSWORD FOR 'debian-sys-maint'@'localhost' = PASSWORD('$passwd');" &&
sed -i /etc/mysql/debian.cnf \
    -e "/^password/c password = $passwd"

### set the password for the root user of mysql
passwd=$(mcookie | head -c 16)
query="update mysql.user set authentication_string=PASSWORD(\"$passwd\") where User=\"root\"; flush privileges;"
debian_cnf=/etc/mysql/debian.cnf
mysql --defaults-file=$debian_cnf -B -e "$query"
