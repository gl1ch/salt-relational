{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/ssl/openssl.cnf' %}                               
{% set conf_path='salt://linux-server/openssl/debian-openssl.jinja' %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/pki/tls/openssl.cnf' %}
{% set conf_path='salt://linux-server/openssl/redhat-openssl.jinja' %}
{% endif %}

openssl-package:
  pkg:
    - name: openssl
    - order: 100
    - installed

openssl-config:
  file.managed:
    - name: {{ path }}
    - source: {{ conf_path }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - order: 101
    - require:
      - pkg: openssl-package

