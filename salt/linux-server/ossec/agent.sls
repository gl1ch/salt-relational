include:
  - linux-server.ossec

{# Use events/reactor system to start up the ossec-authd process on the OSSEC master #}
server-auth:
  cmd.run:
    - name: salt-call event.fire_master 'ossec-auth-start' 'ossec'
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/etc/client.keys
    - order: 510

{# OSSEC authd agent connects to master and registers its key #}
agent-auth:
  cmd.wait:
    - name: sleep 1 && {{ pillar['service-ossec']['userdir'] }}/bin/agent-auth -m {{ pillar['service-ossec']['server_ip'] }} -p 1515
    - unless: stat {{ pillar['service-ossec']['userdir'] }}/etc/client.keys
    - order: 511
    - watch: 
      - cmd.run: server-auth

{# We are done creating our key so lets shut down the ossec-auth process on the master using reactor #}
server-auth-shutdown:
  cmd.wait:
    - name: salt-call event.fire_master 'ossec-auth-stop' 'ossec'
    - order: 512
    - watch:
      - cmd.wait: agent-auth

{# Start the OSSEC services on the agent #}
ossec-service:
  service.running:
    - name: ossec
    - enable: True
    - sig: ossec-syscheckd
    - order: 513
    - require:
      - cmd: agent-auth
