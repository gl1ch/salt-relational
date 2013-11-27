ssldev-package:
  pkg:
    - name: {{ pillar['packages']['ssl-dev'] }}
    - order: 50
    - installed
