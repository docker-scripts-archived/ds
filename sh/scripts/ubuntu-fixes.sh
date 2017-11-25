#!/bin/bash -x

### Fix a warning message from logrotate and rsyslog
### See: https://github.com/ouvrages/rsyslog/commit/ad4cc8949c9caa1e3c95389238f0b637a5325fa2
sed -i /etc/logrotate.d/rsyslog \
    -e 's/invoke-rc.d rsyslog rotate/invoke-rc.d --quiet rsyslog rotate/'
