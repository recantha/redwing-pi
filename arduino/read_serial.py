#!/usr/bin/env python

import serial

ser = serial.Serial('/dev/ttyACM0', 9600)
while True:
	line=ser.readline()
	print(line)

