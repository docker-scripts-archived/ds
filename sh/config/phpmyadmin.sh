#!/bin/bash
### install phpmyadmin

apt-get install phpmyadmin

### make login expiration time longer
sed -i /etc/phpmyadmin/config.inc.php \
    -e "/Don't expire login quickly/,$ d"
cat <<EOF >> /etc/phpmyadmin/config.inc.php
// Don't expire login quickly
\$sessionDuration = 60*60*24*7; // 60*60*24*7 = one week
ini_set('session.gc_maxlifetime', \$sessionDuration);
\$cfg['LoginCookieValidity'] = \$sessionDuration;
EOF
