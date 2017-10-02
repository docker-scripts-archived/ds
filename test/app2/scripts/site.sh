#!/bin/bash -x

source /host/settings.sh

case $1 in
    enable)
        a2ensite default
        a2dissite 000-default
        service apache2 restart
        ;;
    disable)
        a2ensite 000-default
        a2dissite default
        service apache2 restart
        ;;
    *)
        echo "Usage: $0 [enable | disable]"
        ;;
esac
