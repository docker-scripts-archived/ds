#!/bin/bash -x

source /host/settings.sh
DOMAIN=${DOMAIN:-$IMAGE.example.org}

mkdir -p /var/log/apache2

### create a configuration file
mkdir -p /var/www/default
cat <<EOF > /etc/apache2/sites-available/default.conf
<VirtualHost *:80>
        ServerName $DOMAIN
        RedirectPermanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost _default_:443>
        ServerName $DOMAIN

        DocumentRoot /var/www/default
        <Directory /var/www/default/>
            AllowOverride All
        </Directory>

        SSLEngine on
        SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
                        SSLOptions +StdEnvVars
        </FilesMatch>
</VirtualHost>
EOF

### we need to refer to the apache2 config by the name "$DOMAIN.conf" as well
ln /etc/apache2/sites-available/{default,$DOMAIN}.conf

### enable ssl etc.
a2enmod ssl
a2ensite default
a2dissite 000-default
service apache2 restart

### create a script to check for apache2, and start it if not running
cat <<'EOF' > /usr/local/sbin/apachemonitor.sh
#!/bin/bash
# restart apache if it is down

if ! /usr/bin/pgrep apache2
then
    date >> /usr/local/apachemonitor.log
    rm /var/run/apache2/apache2.pid
    /etc/init.d/apache2 restart
fi
EOF
chmod +x /usr/local/sbin/apachemonitor.sh

### setup a cron job to monitor apache2
mkdir -p /etc/cron.d/
cat <<'EOF' > /etc/cron.d/apachemonitor
* * * * * root /usr/local/sbin/apachemonitor.sh >/dev/null 2>&1
EOF
chmod +x /etc/cron.d/apachemonitor
