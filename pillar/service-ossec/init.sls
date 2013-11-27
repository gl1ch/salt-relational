service-ossec:
  version: '2.7' {# version of software to be installed (taken off of .tar file) #}
  language: 'en'
  userdir: '/var/ossec' {# Installation path #}
  en_active_response: 'y' {# Enable active response #}
  en_syscheck: 'y' {# Enable system checks #}
  en_rootcheck: 'y' {# Enable rootkit detection #}
  en_update_rules: 'y' {# Update rules #}
  en_syslog: 'y' {# Enable syslog checks #}
  server_ip: '192.168.5.20' {# IP of the OSSEC master server #}
  en_email: 'y' {# Enable email notifications #}
  email_address: 'alers@domain.com' {# Email address to send notifications #}
  white-list: '192.168.5.0/24' {# IP whitelist #}
  uid: 7000
  gid: 7000
