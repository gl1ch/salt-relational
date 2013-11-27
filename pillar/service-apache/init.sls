service-apache:
  document_root: /var/www
{% if grains['os_family'] == 'Debian' %}
  user: www-data
  group: www-data
  ssl_root: /etc/ssl/localcerts
{% elif grains['os_family'] == 'RedHat' %}
  user: apache
  group: apache
  ssl_root: /etc/pki/tls/certs
{% endif %}
