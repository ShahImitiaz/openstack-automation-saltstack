append_wsgi-keystone.conf_part1:
  file.managed:
    - name: /etc/apache2/sites-available/wsgi-keystone.conf
    - create: true
    - contents:
        - Listen 5000
        - Listen 35357
        - <VirtualHost *:5000>
        - WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        - WSGIProcessGroup keystone-public
        - WSGIScriptAlias / /usr/bin/keystone-wsgi-public
        - WSGIApplicationGroup %{GLOBAL}
        - WSGIPassAuthorization On
        - <IfVersion >= 2.4>
        - ErrorLogFormat "%{cu}t %M"
        - </IfVersion>
        - ErrorLog /var/log/apache2/keystone.log
        - CustomLog /var/log/apache2/keystone_access.log combined
        - <Directory /usr/bin>
        - <IfVersion >= 2.4>
        - Require all granted
        - </IfVersion>
        - <IfVersion < 2.4>
        - Order allow,deny
        - Allow from all
        - </IfVersion>
        - </Directory>
        - </VirtualHost>
        - <VirtualHost *:35357>
        - WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        - WSGIProcessGroup keystone-admin
        - WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
        - WSGIApplicationGroup %{GLOBAL}
        - WSGIPassAuthorization On
        - <IfVersion >= 2.4>
        - ErrorLogFormat "%{cu}t %M"
        - </IfVersion>
        - ErrorLog /var/log/apache2/keystone.log
        - CustomLog /var/log/apache2/keystone_access.log combined
        - <Directory /usr/bin>
        - <IfVersion >= 2.4>
        - Require all granted
        - </IfVersion>
        - <IfVersion < 2.4>
        - Order allow,deny
        - Allow from all
        - </IfVersion>
        - </Directory>
        - </VirtualHost>

append_keystone.override:
  file:
    - append
    - name: /etc/init/keystone.override
    - text: manual

link_to_wsgi: 
  cmd: 
    - run
    - name: ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
