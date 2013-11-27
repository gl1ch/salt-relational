{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/mysql/my.cnf' %}
{% set conf_path='salt://linux-server/mysql/debian-my.jinja' %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/my.cnf' %}
{% set conf_path='salt://linux-server/mysql/redhat-my.jinja' %}
{% endif %}

include:
  - common.python-mysql

mysql-package:
  pkg:
    - name: mysql-server 
    - order: 100
    - installed

mysql-service:
  service:
    - name: {{ pillar['packages']['mysql-service'] }}
    - running
    - order: 101
    - require:
      - pkg: mysql-package

mysql-config:
  file.managed:
    - name: {{ path }}
    - source: {{ conf_path }} 
    - user: root
    - group: root
    - mode: 644
    - order: 102
    - require:
      - pkg: mysql-package

mysql-root:
  mysql_user.present:
    - name: {{ pillar['service-mysql']['my_admin'] }}
    - password: '{{ pillar['service-mysql']['my_admin_pass'] }}'
    - order: 103
    - require:
      - service: mysql-service

mysql-backup:
  file.directory:
    - name: /var/backup
    - user: root
    - group: root
    - mode: 770
  cron.present:
    - name: mysqldump --all-databases -p | bzip2 -c > /var/backup/db.sql.bz2
    - user: root
    - minute: 59
    - hour: 23
