#!/usr/bin/python

import subprocess as sub

while True:
	outp = sub.Popen(['./pipodcorder.py'], stdout=sub.PIPE, stderr=sub.PIPE)
	result = outp.communicate()[0]
	print "Finished"