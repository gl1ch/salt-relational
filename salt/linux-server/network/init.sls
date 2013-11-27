{% set hostname=grains['id'] %}

{% if grains['os_family'] == 'Debian' %}
network-configuration:
  file.managed:
    - name: /etc/network/interfaces
    - user: root
    - group: root
    - mode: 644
    - source: salt://linux-server/network/interfaces.jinja
    - template: jinja
  cmd.wait:
    - name: /etc/init.d/networking restart && service salt-minion restart
    - user: root
    - order: 10
    - watch:
      - file: network-configuration
{% elif grains['os_family'] == 'RedHat' %}
system:
  network.system:
    - enabled: True
    - hostname: {{ hostname }}
    - gateway: {{ pillar['servers'][hostname]['gateway'] }}
    - gatewaydev: {{  pillar['servers'][hostname]['gwdev'] }}
    - order: 10

{% for adapter, args in pillar['servers'][hostname]['network_adapters'].iteritems() %}
{{ adapter }}:
  network.managed:
    - enabled: {{ args['en'] }} 
    - type: eth
    - ipaddr: {{ args['ip'] }}
    - netmask: {{ args['sn'] }}
    - order: 10
{% endfor %}
    - dns:
    {% for dns in pillar['servers'][hostname]['dns'] %}
      - {{ dns }}
    {% endfor %}
{% endif %}

