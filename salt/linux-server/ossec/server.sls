{% set hostname=grains['id'] %}
{% set domain=pillar['servers'][hostname]['domain'] %}

include:
  - linux-server.ossec

rules-config:
  file.managed:
    - name: {{ pillar['service-ossec']['userdir'] }}/rules/local_rules.xml
    - source: salt://linux-server/ossec/local_rules.xml
    - user: root
    - group: ossec
    - mode: 550 
    - order: 510

ssl-key:
  cmd.run:
    - name: openssl genrsa -out {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.key 2048
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.key
    - order: 510

ssl-cert:
  cmd.run:
    - name: openssl req -subj 
            '/CN={{ hostname }}.{{ domain -}}
            /C={{ pillar['service-openssl']['countrynamedefault'] -}}
            /ST={{ pillar['service-openssl']['stateorprovincenamedefault'] -}}
            /O={{ pillar['service-openssl']['orgnamedefault'] }}'
            -new -x509 -key {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.key 
            -out {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.cert 
            -days 730
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.cert 
    - onlyif: stat {{ pillar['service-ossec']['userdir'] }}/etc/sslmanager.key
    - order: 510

ossec-service:
  service.running:
    - name: ossec
    - enable: True
    - sig: ossec-syscheckd
    - order: 511
    - require:
      - cmd.run: ossec-install

{# Since OSSEC does not recommend keeping authd running my workaround so far is to run a cron job
   to shut it off after a period of time. I need to figure out a better way of doing this in the 
   future as this may require more than one highstate to add keys for a client and it is cheesy #}

pkill ossec-authd >/dev/null 2>&1:
  cron.present:
    - user: root
    - minute: '*/5' 
