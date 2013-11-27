snmp-package:
  pkg:
    - name: {{ pillar['packages']['snmp'] }}
    - installed

snmp-service:
  service:
    - name: {{ pillar['packages']['snmp-service'] }}
    - running
    - watch:
      - pkg: snmp-package
      - file: /etc/snmp/snmpd.conf
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - user: root
    - group: root
    - mode: 600
    - source: salt://linux-server/snmp/snmpd.jinja
    - template: jinja
    - require:
      - pkg: snmp-package
