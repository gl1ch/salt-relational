websites:
  www:
    ip: 192.168.5.101
    sitename: www.domain.com
    sitealias:
      - www
    ssl: False
    auth: 'group'
    auth-name: Welcome to Domain.com 
    group:
      - users
      - "Domain Admins"
    allowed:
      - 127.0.0.1
      - 192.168.5.0/24 

