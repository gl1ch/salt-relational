#!/usr/bin/python
# Generate hashed passwords for use in the users pillar

import crypt
import os

prompt = raw_input('Type in password to generate a hash: ')
salt = os.urandom(8)
hash = crypt.crypt(prompt, '$6$%s$' % salt)
print 'Your password hash is:'
print ('\r')
print hash
print ('\r')
