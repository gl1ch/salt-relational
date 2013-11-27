apt-proxy:
  file.managed:
    - name: /etc/apt/apt.conf.d/01-proxy
    - source: salt://common/apt/proxy.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - cmd.wait:
      - name: apt-get update
      - watch:
        - file: apt-proxy
