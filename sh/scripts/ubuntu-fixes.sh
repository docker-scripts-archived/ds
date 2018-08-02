#!/bin/bash -x

### Fix an error message from rsyslog
### See: https://github.com/rsyslog/rsyslog-pkg-ubuntu/issues/74
sed -i /usr/lib/rsyslog/rsyslog-rotate \
    -e 's/systemctl kill -s HUP rsyslog.service/systemctl restart rsyslog.service/'
