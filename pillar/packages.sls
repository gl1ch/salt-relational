packages:
{% if grains['os_family'] == 'Debian' %}
  apache: apache2
  php: libapache2-mod-php5
  git: git-core
  snmp: snmpd
  snmp-service: snmpd
  ssh: ssh 
  ssh-service: ssh 
  vi: vim
  ntp: ntp
  ntp-service: ntp
  python-mysql: python-mysqldb
  mysql-service: mysql
  winbind: winbind
  samba-service: smbd
  build-env: build-essential
  ssl-dev: libssl-dev
  auth-pam: libapache2-mod-auth-pam
  bind: bind9
  bind-service: bind9
  svn-apache: libapache2-svn
{% elif grains['os_family'] == 'RedHat' %}
  apache: httpd
  php: php
  git: git
  snmp: net-snmp
  snmp-service: snmpd
  ssh: openssh
  ssh-service: sshd
  vi: vim-enhanced
  ntp: ntp
  ntp-service: ntpd
  python-mysql: MySQL-python
  mysql-service: mysqld
  winbind: samba-winbind
  samba-service: smb
  build-env: make
  ssl-dev: openssl-devel
  auth-pam: mod_auth_pam
  bind: bind
  bind-service: named
  svn-apache: mod_dav_svn
{% endif %}
