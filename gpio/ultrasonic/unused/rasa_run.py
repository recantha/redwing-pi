#!/usr/bin/python
from time import sleep
import SensorLibs as HYSRF05

ultrasonic_sensor = HYSRF05.Ultrasonic_Sensor(trigger_pin=4, echo_pin=17, number_of_samples=10)

while True:
	print "avg: %s" % ultrasonic_sensor.get_reading()
	sleep(1)

