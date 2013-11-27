{% set hostname = grains['id'] %}
{% set version = pillar['service-ossec']['version'] %}
{% set ossecdir = 'ossec-hids-{0}'.format(version) %}

include:
  - linux-server.build-utils
  - linux-server.build-utils.ssldev

ossec-install-directory:
  file.directory:
    - name: /usr/src/ossec-install
    - order: 500

ossec-download-installer:
  file.managed:
    - source: salt://linux-server/ossec/files/{{ ossecdir }}.tar.gz
    - name: /usr/src/ossec-install/{{ ossecdir }}.tar.gz
    - order: 501
    - require:
      - file: ossec-install-directory

ossec-extract-installer:
  cmd.run:
    - name: 'tar -zxf {{ ossecdir }}.tar.gz'
    - cwd: '/usr/src/ossec-install/'
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/bin/ossec-control
    - order: 502
    - watch:
      - file: ossec-download-installer

ossec-installer-variables:
  file.managed:
    - name: '/usr/src/ossec-install/{{ ossecdir }}/etc/preloaded-vars.conf'
    - source: 'salt://linux-server/ossec/preloaded-vars.jinja'
    - template: jinja
    - order: 504
    - watch:
      - cmd: ossec-extract-installer

ossec:
  user.present:
    - fullname: OSSEC Service Account
    - home: {{ pillar['service-ossec']['userdir'] }}
    - shell: /bin/false
    - uid: {{ pillar['service-ossec']['uid'] }}
    - gid: {{ pillar['service-ossec']['gid'] }}
    - order: 12
  group.present:
    - gid: {{ pillar['service-ossec']['gid'] }}
    - order: 11

ossec-install:
  cmd.run:
    - name: '/usr/src/ossec-install/{{ ossecdir }}/install.sh'
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/bin/ossec-control
    - require:
      - pkg: make-package
      - pkg: gcc-package
      - pkg: ssldev-package
    - order: 505
    - watch:
      - file: ossec-installer-variables
