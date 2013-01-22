#!/usr/bin/python
import RPi.GPIO as GPIO
from datetime import datetime
import time

trigger_pin=27
echo_pin=22
number_of_samples=10

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(trigger_pin, GPIO.OUT)
GPIO.setup(echo_pin, GPIO.IN)

number_of_readings=20
all_readings = []
for j in range(number_of_readings):
	reading_list = []
	for i in range(number_of_samples):
		time.sleep(0.0050) # 50 ms is the maximum timout if nothing in range.
		
		# set our trigger high, triggering a pulse to be sent.
		GPIO.output(trigger_pin, GPIO.HIGH)
		time.sleep(0.00001)
		GPIO.output(trigger_pin, GPIO.LOW)
	
		while not GPIO.input(echo_pin):
			# Wait for our pin to go high, waiting for a response.
			pass
	
		# Now its high, get our start time
		start = datetime.now()
	
		while GPIO.input(echo_pin):
			# wait for our input to go low
			pass
  		# Now its low, grab our end time
		end = datetime.now()
	
		# Store our delta.
		delta = end - start
		reading_list.append(delta.microseconds)
	
		# take a little break, it appears to help stabalise readings
		# I suspect due to less interfearance with previous readings 
		time.sleep(0.000002)

	average_reading = sum(reading_list)/number_of_samples

	all_readings.append(average_reading)
average_of_all_readings = sum(all_readings)/number_of_readings
average_distance=average_of_all_readings * 340
average_distance=average_distance/20000
print "%s cm" % average_distance
