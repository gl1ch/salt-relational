{% set hostname=grains['id'] -%}
{% if grains['os_family'] == 'Debian' %}
{% set file_check=salt['file.directory_exists']('/etc/apache') %}
{% elif grains['os_family'] == 'RedHat' %}
{% set file_check=salt['file.directory_exists']('/etc/httpd') %}
{% endif %}

include:
  - linux-server.apache.server
  - linux-server.openssl
  - linux-server.apache.websites
  {# Need to rewrite this once state_auto_order comes into a release #}
  {% if pillar['servers'][hostname]['websites'] is defined and file_check == True %}
  - linux-server.apache.websites
  {% endif %}
