ssh-package:
  pkg:
    - name: {{ pillar['packages']['ssh'] }}
    - installed

ssh-service:
  service:
    - name: {{ pillar['packages']['ssh-service'] }}
    - running
    - watch:
      - pkg: ssh-package 
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://linux-server/ssh/sshd_config.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: ssh-package

/etc/ssh/banner:
  file.managed:
    - source: salt://linux-server/ssh/banner
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh-package
