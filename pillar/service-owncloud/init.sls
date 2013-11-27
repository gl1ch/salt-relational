service-owncloud:
  owncloud_version: 5.0.9
  owncloud_type: enterprise {# leave this undefined if using community edition #}
  php_upload_max_filesize: 512M
  php_post_max_size: 512M
  php_memory_limit: 512M
  oc_insanceid: 398hfksnf93hfa
  oc_passwordsalt: 239ruyhaiwf8ah3funsde8f7h3nsdf8h3
  oc_datadirectory: /var/owncloud_data
  oc_dbtype: mysql
  oc_version: 5.0.15
  oc_dbname: owncloud
  oc_dbhost: localhost
  oc_dbuser: admin
  oc_dbpassword: mypassword
  oc_theme: custom 
  oc_mail_smtpmode: smtp
  oc_mail_smtphost: 192.168.5.15
  oc_mail_smtpauth: false
  oc_installed: true
  oc_ldapIgnoreNamingRules: false
  oc_forcessl: false
  oc_loglevel: 0
  oc_maxZipInputSize: 8332843800
  oc_allowZipDownload: true
  oc_versions: false
