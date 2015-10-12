#!/usr/bin/env python

import os

file = os.getenv('HOME') + '/a.txt'

#if os.path.exists(file):
#	for line in open(file, 'r'):
#	    print line,
#
#else:
#	print 'err'

if os.path.exists(file):
	f = open(file)
	list = f.readlines()
	f.close()

else:
	print 'err'

#print list

for line in list:
	print line,
