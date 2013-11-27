salt-minion-pkg:
  pkg:
    - name: salt-minion
    - installed

salt-minion-service:
  service:
    - name: salt-minion
    - running
    - watch:
      - pkg: salt-minion-pkg
      - file: /etc/salt/minion

salt-minion-config:
  file.managed:
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 640
    - source: salt://linux-server/salt/minion.jinja
    - template: jinja
    - require:
      - pkg: salt-minion-pkg

salt:
  user.present:
    - fullname: SALT Service Account
    - home: {{ pillar['service-salt']['userdir'] }}
    - shell: /bin/bash
    - uid: {{ pillar['service-salt']['uid'] }}
    - gid: {{ pillar['service-salt']['gid'] }}
    - order: 12
  group.present:
    - gid: {{ pillar['service-salt']['gid'] }}
    - order: 11

/var/cache/salt:
  file.directory:
    - user: {{ pillar['service-salt']['user'] }} 
    - group: {{ pillar['service-salt']['user'] }}
    - mode: 755
    - require:
      - user: salt

/var/log/salt:
  file.directory:
    - user: {{ pillar['service-salt']['user'] }}
    - group: {{ pillar['service-salt']['user'] }}
    - mode: 744
    - require:
      - user: salt 

/etc/salt/pki:
  file.directory:
    - user: {{ pillar['service-salt']['user'] }}
    - group: {{ pillar['service-salt']['user'] }}
    - mode: 700
    - require:
      - user: salt
