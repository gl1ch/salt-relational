{% set version = pillar['service-owncloud']['owncloud_version'] %}
{% if pillar['service-owncloud']['owncloud_type'] is defined %}
{% set ocdir = 'owncloud_enterprise-{0}'.format(version) %}
{% else %}
{% set ocdir = 'owncloud-{0}'.format(version) %}
{% endif %}
{# In order to work as intended this state requires the apache state I created as well as
a definition for the owncloud site in the websites.sls and server.sls pillar #}

include:
  - common.python-mysql
  - linux-server.php
  - linux-server.apache
  - linux-server.mysql
  - linux-server.build-utils
  - linux-server.build-utils.ssldev

oc-install-directory:
  file.directory:
    - name: /usr/src/owncloud-install
    - order: 503

oc-download-installer:
  file.managed:
    - source: salt://linux-server/owncloud/files/{{ ocdir }}.tar.bz2
    - name: /usr/src/owncloud-install/{{ ocdir }}.tar.bz2
    - order: 504
    - require:
      - file: oc-install-directory

oc-extract-installer:
  cmd.wait:
    - name: 'tar -jxf /usr/src/owncloud-install/{{ ocdir }}.tar.bz2'
    - cwd: {{ pillar['service-apache']['document_root'] }}
{#    - unless: stat {{ pillar['service-apache']['document_root'] }}/owncloud/config/config.php #}
    - order: 505
    - watch:
      - file: oc-download-installer

owncloud-site:
  file.directory:
    - name: {{ pillar['service-apache']['document_root'] }}/owncloud
    - user: {{ pillar['service-apache']['user'] }}
    - group: {{ pillar['service-apache']['group'] }}
    - recurse:
      - user
      - group
    - order: 506
    - watch:
      - cmd: oc-extract-installer

owncloud-data:
  file.directory:
    - name: {{ pillar['service-owncloud']['oc_datadirectory'] }}
    - user: {{ pillar['service-apache']['user'] }}
    - group: {{ pillar['service-apache']['group'] }}
    - mode: 770
    - order: 506
    - require:
      - cmd: oc-extract-installer

oc-theme:
  file.recurse:
    - name: {{ pillar['service-apache']['document_root'] }}/owncloud/themes
    - source: salt://linux-server/owncloud/files/themes
    - order: 507
    - require:
      - cmd: oc-extract-installer

owncloud-config-file:
  file.managed:
    - name: {{ pillar['service-apache']['document_root'] }}/owncloud/config/config.php
    - user: {{ pillar['service-apache']['user'] }}
    - group: {{ pillar['service-apache']['group'] }}
    - mode: 640
    - source: salt://linux-server/owncloud/config.jinja
    - template: jinja
    - order: 508
    - watch:
      - cmd: oc-extract-installer
    - require:
      - cmd: oc-extract-installer

owncloud-htaccess-file:
  file.managed:
    - name: {{ pillar['service-apache']['document_root'] }}/owncloud/.htaccess
    - user: {{ pillar['service-apache']['user'] }}
    - group: {{ pillar['service-apache']['group'] }}
    - mode: 640
    - source: salt://linux-server/owncloud/htaccess.jinja
    - template: jinja
    - order: 508
    - require:
      - cmd: oc-extract-installer

owncloud_database:
  mysql_database.present:
    - name: {{ pillar['service-owncloud']['oc_dbname'] }}
    - order: 600
    - require:
      - pkg: python-package
      - service: mysql-service
      - mysql_user: mysql-root
  mysql_user.present:
    - name: {{ pillar['service-owncloud']['oc_dbuser'] }}
    - password: {{ pillar['service-owncloud']['oc_dbpassword'] }}
    - order: 601
    - require:
      - pkg: python-package
      - service: mysql-service
      - mysql_user: mysql-root
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['service-owncloud']['oc_dbname'] }}.*
    - user: {{ pillar['service-owncloud']['oc_dbuser'] }}
    - host: {{ pillar['service-owncloud']['oc_dbhost'] }}
    - order: 602
    - require:
      - pkg: python-package
      - service: mysql-service
      - mysql_user: mysql-root 
