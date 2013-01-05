#!/usr/bin/python

import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setup(15, GPIO.IN)
GPIO.setup(16, GPIO.OUT)

print "Entering giggle mode"

count = 0
allow_press = 1

GPIO.output(16, True)

while True:
	tactile1 = GPIO.input(15)
	print "Tactile 1 is currently ",tactile1
	if (allow_press == 1):
		if (tactile1 == True):
			count = count+1
			print "giggle ", count
			GPIO.output(16, False)
			allow_press = 0
			time.sleep(0.2)
	else:
		if (tactile1 == False):
			allow_press = 1
			GPIO.output(16, True)
			time.sleep(0.2)

