#!/bin/bash -x
### install phpmyadmin

DEBIAN_FRONTEND=noninteractive \
    apt -y install phpmyadmin

if [[ -n $DEV ]]; then
    ### make login expiration time longer
    sed -i /etc/phpmyadmin/config.inc.php \
        -e "/Don't expire login quickly/,$ d"
    cat <<EOF >> /etc/phpmyadmin/config.inc.php
// Don't expire login quickly
\$sessionDuration = 60*60*24*7; // 60*60*24*7 = one week
ini_set('session.gc_maxlifetime', \$sessionDuration);
\$cfg['LoginCookieValidity'] = \$sessionDuration;
EOF
fi

ln -sf /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
service apache2 reload
