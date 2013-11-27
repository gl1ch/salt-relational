{% for group, args in pillar['groups'].iteritems() %}
{{ group }}:
  group.present:
    - name: {{ group }}
    {% if 'gid' in args %}
    - gid: {{ args['gid'] }}
    {% endif %}
    - order: 10
{% endfor %}

{% for user, args in pillar['users'].iteritems() %}
{{ user }}:
  user.present:
    - fullname: {{ args['fullname'] }}
    {% if user != 'root' %}
    - home: /home/{{ user }}
    {% endif %}
    - uid: {{ args['uid'] }}
    - gid: {{ args['gid'] }}
    - shell: {{ args['shell'] }}
    - require:
      - group: {{ user }}    
    {% if 'password' in args %}
    - password: {{ args['password'] }}
    {% endif %}
    {% if 'enforce_password' in args %}
    - enforce_password: {{ args['enforce_password'] }}
    {% endif %}
    {% if 'groups' in args %}
    - groups: {{ args['groups'] }}
    {% endif %}
    - order: 11
  group.present:
    - gid: {{ args['gid'] }}
    - order: 12

{% if 'key' in args and args['key'] == True %}
{{ user }}.pub:
  ssh_auth:
    - present
    - user: {{ user }}
    - source: salt://linux-server/users/keys/{{ user }}.pub
    - order: 13
    - require:
      - user: {{ user }}
{% endif %}
{% endfor %}


