{% if grains['os_family'] == 'Debian' %}
{% set path='/etc/php5/apache2/php.ini' %}
{% elif grains['os_family'] == 'RedHat' %}
{% set path='/etc/php.ini' %}
{% endif %}

php-package:
  pkg:
    - name: {{ pillar['packages']['php'] }}
    - order: 100
    - installed

php-config:
  file.managed:
    - name: {{ path }}
    - source: salt://linux-server/php/php.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - order: 101
    - require:
      - pkg: php-package
