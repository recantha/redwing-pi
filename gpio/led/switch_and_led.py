#!/usr/bin/python

import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setup(11, GPIO.IN)
count = 0

allow_press = 1
while True:
	tactile1 = GPIO.input(11)
	if (allow_press == 1):
		if (tactile1 == False):
			count = count+1
			print "giggle", count
			allow_press = 0
	else:
		if (tactile1 == True):
			allow_press = 1

