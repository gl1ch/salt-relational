{% set hostname=grains['id'] -%}
{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/apache2/sites-available/default' %}
{% set conf_path='salt://linux-server/apache/debian-default.jinja' %}
{% set file_check=salt['file.directory_exists']('/etc/apache') %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/httpd/conf/httpd.conf' %}
{% set conf_path='salt://linux-server/apache/redhat-httpd.jinja' %}
{% set file_check=salt['file.directory_exists']('/etc/httpd') %}
{% endif %}

{% if salt['file.directory_exists']('/etc/nginx') %}
nginx-service:
  service:
    - name: nginx
    - enable: False
    - dead
{% endif %}

apache-package:
  pkg:
    - name: {{ pillar['packages']['apache'] }}
    - order: 100
    - installed

apache-pam-package:
  pkg:
    - name: {{ pillar['packages']['auth-pam'] }}
    - installed
    - order: 101
    - require:
      - pkg: apache-package

{{ pillar['service-apache']['document_root'] }}:
  file:
    - directory
    - user: {{ pillar['service-apache']['user'] }} 
    - group: {{ pillar['service-apache']['group'] }}
    - mode: 770
    - order: 102
    - require:
      - pkg: apache-package

{{ pillar['service-apache']['ssl_root'] }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - order: 103
    - require:
      - pkg: apache-package

apache-config:
  file.managed:
    - name: {{ path }}
    - user: root
    - group: root
    - mode: 755
    - source: {{ conf_path }}
    - template: jinja
    - order: 104
    - require: 
      - pkg: apache-package

apache-service:
  service:
    - name: {{ pillar['packages']['apache'] }}
    - running
    - order: 105
    - require:
      - pkg: apache-package
