include: 
  - salt-minion

salt-master:
  pkg:
    - installed
  service:
    - running
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master
  file.managed:
    - name: /etc/salt/master
    - user: salt 
    - group: root
    - mode: 640
    - source: salt://linux-server/salt/master.jinja
    - template: jinja
    - require:
      - pkg: salt-master
