users:
  root:
    fullname: root
    uid: 0
    gid: 0
    shell: /bin/bash
    password: <Insert Password Hash Here. This can be copied from a servers /etc/shadow or you can use the has generator in the SCRIPTS>
    enforce_password: True

  user1:
    fullname: Test User
    uid: 1000
    gid: 1000
    shell: /bin/bash
    password: <Insert Password Hash Here. This can be copied from a servers /etc/shadow or you can use the has generator in the SCRIPTS>
    enforce_password: True
    key: True {# Please note that you will need to add the users public key into salt/linux-server/users #}
    groups:
      - admin
