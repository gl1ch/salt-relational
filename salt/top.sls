{% set hostname=grains['id'] %}
{% if grains['kernel'] == 'Linux' %}
{% set kernel='linux' %}
{% elif grains['kernel'] == 'SunOS' %}
{% set kernel='solaris' %}
{% elif grains['kernel'] == 'Windows' %}
{% set kernel='windows' %}
{% elif grains['kernel'] == 'Darwin' %}
{% set kernel='macintosh' %}
{% endif %}

base:

  'kernel:Linux':
    - match: grain
    - linux-server.network
    - linux-server.iptables
    - linux-server.salt.minion
    - linux-server.ntp
    - linux-server.snmp
    - linux-server.users
    - linux-server.ssh
    - linux-server.vim

  'os_family:Debian':
    - match: grain
    - common.apt

  {% if pillar['servers'][hostname] is defined %}
  {% for roles in pillar['servers'][hostname]['roles'] %}
  'servers:{{ hostname }}:roles:{{ roles }}':
    - match: pillar
    - {{ kernel }}-server.{{ roles }}
  {% endfor %}
  {% endif %}

  {% if pillar['desktops'][hostname] is defined %}
  {% for roles in pillar['desktops'][hostname]['roles'] %}
  'desktops:{{ hostname }}:roles:{{ roles }}':
    - match: pillar
    - {{ kernel }}-desktop.{{ roles }}
  {% endfor %}
  {% endif %}
