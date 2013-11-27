{% set hostname=grains['id'] -%}
{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/apache2/sites-available/' %}
{% set file_check=salt['cmd.run']('ls -1 /etc/apache2/sites-enabled/').split('\n') %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/httpd/conf.d/' %}
{% set file_check=salt['cmd.run']("ls -1 /etc/httpd/conf.d/ | cut -d '.' -f1").split('\n') %} 
{% endif %}

{# Clean up any enabled websites or SSL keys that should not be assiciated with a minion #}
{% if pillar['servers'][hostname] is defined %}
{% for filename in file_check if not 'auth_pam.conf' %}
{% if filename not in pillar['servers'][hostname]['websites'] %}
{{filename }}-remove:
  file.absent:
    {% if grains['os_family'] == 'Debian' %}
    - name: /etc/apache2/sites-enabled/{{ filename }}
    {% elif grains['os_family'] == 'RedHat' %}
    - name: /etc/httpd/conf.d/{{ filename }}.conf
    {% endif %}

{{ filename }}-sslkey-remove:
  file.absent:
    - name: {{ pillar['service-apache']['ssl_root'] }}/{{ filename }}.key-nopass

{{ filename }}-sslcert-remove:
  file.absent:
    - name: {{ pillar['service-apache']['ssl_root'] }}/{{ filename }}.pem
{% endif %}
{% endfor %}

{# Create/enable websites as defined from servers.sls and websites.sls in pillar #}
{% for website in pillar['servers'][hostname]['websites'] %}
{{ website }}-config:
  file.managed:
    {% if grains['os_family'] == 'Debian' %}
    - name: {{ path }}{{ website }}
    {% elif grains['os_family'] == 'RedHat' %}
    - name: {{ path }}{{ website }}.conf
    {% endif %}
    - user: root
    - group: root
    - mode: 755
    - source: salt://linux-server/apache/websites/apache-template.jinja
    - context:
      website: {{ website }}
    - template: jinja
    - order: 110
    - require:
      - pkg: apache-package

{% if pillar['websites'][website]['ssl'] == True %}
{{ website }}-sslkey:
  file.managed:
    - name: {{ pillar['service-apache']['ssl_root'] }}/{{ website }}.key-nopass
    - user: root
    - group: root
    - mode: 755
    - source: salt://linux-server/apache/websites/certificates/{{ website }}.key-nopass
    - template: jinja
    - order: 111
    - require:
      - pkg: apache-package

{{ website }}-sslcert:
  file.managed:
    - name: {{ pillar['service-apache']['ssl_root'] }}/{{ website }}.pem
    - user: root
    - group: root
    - mode: 755
    - source: salt://linux-server/apache/websites/certificates/{{ website }}.pem
    - template: jinja
    - order: 112
    - require:
      - pkg: apache-package
{% endif %}

{{ website }}-directory:
  file.directory:
    - name: {{ pillar['service-apache']['document_root'] }}/{{ website }}
    - user: {{ pillar['service-apache']['user'] }}
    - group: {{ pillar['service-apache']['group'] }}
    - mode: 755

{% if grains['os_family'] == 'Debian' %}
/etc/apache2/sites-enabled/{{ website }}:
  file.symlink:
    - target: {{ path }}{{ website }}
    - order: 113
{% endif %}
{% endfor %}

{% endif %}
