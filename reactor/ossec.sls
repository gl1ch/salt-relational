{% if data['data'] == 'ossec-auth-start' %}
ossec-auth-start:
  cmd.cmd.run:
    - tgt: ossec-server.domain.com 
    - arg: 
      - /var/ossec/bin/ossec-authd -p 1515 >/dev/null 2>&1 &
{% elif data['data'] == 'ossec-auth-stop' %}
ossec-auth-stop:
  cmd.cmd.run:
    - tgt: ossec-server.domain.com
    - arg:
      - pkill ossec-authd >/dev/null 2>&1
{% endif %}
