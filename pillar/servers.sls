servers:
  ubuntu01:
    roles:
      - bind.master
      - ossec.server
      - samba 
      - apache  
      - owncloud 
    websites:
      - www
      - owncloud 
    tcp_ports:
      - 80
      - 161
      - 1515
    udp_ports:
      - 161
      - 5050
    smbserverstring: 'My File Server'
    smbshare:
      Applied_Minds: {
      comment: 'Corporate Share',
      path: '/export/corporate' }
      Projects: {
      comment: 'Users Share',
      path: '/export/users' }
    domain: domain.com
    gateway: 192.168.5.1
    gwdev: eth0
    dns:
      - 192.168.5.10
      - 192.168.5.11
    network_adapters:
      eth0: {
      en: 'True',
      ip: 192.168.5.10,
      sn: 255.255.255.0,
      nw: 192.168.5.0,
      bc: 192.168.5.255 }
      eth0:1: {
      en: 'True',
      ip: 192.168.5.100,
      sn: 255.255.255.0, 
      nw: 192.168.5.0, 
      bc: 192.168.5.255 }

  centos01:
    roles:
      - bind
      - ossec.agent
    websites:
      - mysite
    tcp_ports:
      - 80
      - 443
    smbserverstring: 'Another File Server'
    domain: domain.com
    gateway: 192.168.5.1
    gwdev: eth0
    dns:
      - 192.168.5.10
      - 192.168.5.11
    network_adapters:
      eth0: {
      en: 'True',
      ip: 192.168.5.11,
      sn: 255.255.255.0, 
      nw: 192.168.5.0, 
      bc: 192.168.5.255 }
