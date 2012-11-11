import RPi.GPIO as GPIO
import time
 
PIR = 17
LED = 22
 
pirState = False
pirVal = False
 
GPIO.setmode(GPIO.BCM)
GPIO.setup(PIR, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)
 
while True:
	pirVal = GPIO.input(PIR)			# read input value
	
	if (pirVal == True):				# check if the input is HIGH
		GPIO.output(LED, False)		  # turn LED ON
		print "No movement"
		time.sleep(2)
	else:
		GPIO.output(LED, True)		 # turn LED OFF
		print "Movement"
		time.sleep(2)
