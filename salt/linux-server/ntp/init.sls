ntp-package:
  pkg:
    - name: {{ pillar['packages']['ntp'] }}
    - installed

ntp-service:
  service:
    - name: {{ pillar['packages']['ntp-service'] }}
    - running
    - watch:
      - pkg: ntp-package
      - file: /etc/ntp.conf 
  file.managed:
    - name: /etc/ntp.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://linux-server/ntp/ntp.jinja
    - template: jinja
    - require:
      - pkg: ntp-package
