{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/network/if-pre-up.d/iptables' %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/sysconfig/iptables' %} 
{% endif %}

iptables:
  pkg:
    - installed
  file.managed:
    - name: {{ path }}
    - user: root
    - group: root
    - mode: 755
    - source: salt://linux-server/iptables/iptables.jinja
    - template: jinja
  cmd.wait:
    - name: iptables-restore < {{ path }}
    - order: 11
    - watch: 
      - file: iptables
    - require:
      - pkg: iptables
