#!/usr/bin/python
# PiPodCorder main script
# for Raspberry Pi
# by Michael Horne (www.recantha.co.uk/blog)
# Date: 27/10/2012

# Contributions taken from
# HD44780 LCD Test Script
# Author : Matt Hawkins
# Site	 : http://www.raspberrypi-spy.co.uk

# Adafruit I2C Library

#import
import RPi.GPIO as GPIO
import time
import os
import socket
import commands
import subprocess as sub
import serial
import pyfirmata
import sys

from datetime import datetime

###################
# LCD CONFIGURATION
###################
# Define GPIO to LCD mapping
LCD_RS = 7
LCD_E	= 8
LCD_D4 = 25 
LCD_D5 = 24
LCD_D6 = 23
LCD_D7 = 18

# Define some device constants
LCD_WIDTH = 16		# Maximum characters per line
LCD_CHR = True
LCD_CMD = False

LCD_LINE_1 = 0x80 # LCD RAM address for the 1st line
LCD_LINE_2 = 0xC0 # LCD RAM address for the 2nd line 

# Timing constants
E_PULSE = 0.00005
E_DELAY = 0.00005

# Not used for Firmata
#	SERIAL = serial.Serial('/dev/ttyACM0', 9600)

# Define Firmata-enabled Arduino
FIRMATA_BOARD = pyfirmata.Arduino('/dev/ttyACM0')
it = pyfirmata.util.Iterator(FIRMATA_BOARD)
it.start()

FIRMATA_PIN_TEMPERATURE=FIRMATA_BOARD.get_pin('a:3:i')
FIRMATA_PIN_MAGNET=FIRMATA_BOARD.get_pin('a:1:i')
FIRMATA_PIN_LDR=FIRMATA_BOARD.get_pin('a:2:i')
FIRMATA_PIN_RED_LED=FIRMATA_BOARD.get_pin('d:10:p')
FIRMATA_PIN_GREEN_LED=FIRMATA_BOARD.get_pin('d:9:p')
FIRMATA_PIN_MENU_STEP=FIRMATA_BOARD.get_pin('d:6:i')
FIRMATA_PIN_MENU_EXIT=FIRMATA_BOARD.get_pin('d:5:i')
FIRMATA_PIN_US_TRIGGER=FIRMATA_BOARD.get_pin('d:3:p')
FIRMATA_PIN_US_ECHO=FIRMATA_BOARD.get_pin('d:2:i')

trigger_pin=27
echo_pin=22
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(trigger_pin, GPIO.OUT)
GPIO.setup(echo_pin, GPIO.IN)



#################################
# TRICORDER FUNCTIONS
#################################

def get_ip_addresses():
	FIRMATA_PIN_GREEN_LED.write(1)
	ips = commands.getoutput("/sbin/ifconfig | grep -i \"inet\" | grep -iv \"inet6\" | " + "awk {'print $2'} | sed -ne 's/addr\:/ /p'")
	addrs = ips.split('\n')
	FIRMATA_PIN_GREEN_LED.write(0)
	return addrs



def read_temperature():
	FIRMATA_PIN_GREEN_LED.write(1)
	gettemp = sub.Popen(['gpio/tmp102/temperature_read.sh'], stdout=sub.PIPE, stderr=sub.PIPE)
	temp = gettemp.communicate()
	FIRMATA_PIN_GREEN_LED.write(0)
	return temp[0]




def read_ultrasonic():
	number_of_readings=5
	number_of_samples=15
	ping_timeout=200000
	debug = False

	all_readings = []
	for j in range(number_of_readings):

	        reading_list = []
		readings_used = 0
	        for i in range(number_of_samples):
			# 50 ms is the max timeout if nothing in range.
	               	# time.sleep(0.005)
			timeout_flag = False

			FIRMATA_PIN_RED_LED.write(1)
			FIRMATA_PIN_GREEN_LED.write(0)

	                # set our trigger high, triggering a pulse to be sent.
	                GPIO.output(trigger_pin, GPIO.HIGH)
	                time.sleep(0.00001)
	                GPIO.output(trigger_pin, GPIO.LOW)

			timeout_start = datetime.now()

			# Wait for our pin to go high, waiting for a response.
	                while not GPIO.input(echo_pin):
				timeout_end = datetime.now()
				timeout_delta = timeout_end - timeout_start
				if timeout_delta.microseconds > ping_timeout:
					if debug:
						print "Timeout A"
					timeout_flag = True
					break
	                        pass

			# Now its high, get our start time
			timeout_start = datetime.now()
	                start = datetime.now()
	
			# wait for our input to go low
	                while GPIO.input(echo_pin):
				timeout_end = datetime.now()
				timeout_delta = timeout_end - timeout_start
				if timeout_delta.microseconds > ping_timeout:
					if debug:
						print "Timeout B"
					timeout_flag = True
					break
	                        pass

	                # Now its low, grab our end time
	                end = datetime.now()

	                # Store our delta.
			if not timeout_flag:
	                	delta = end - start
	   			reading_list.append(delta.microseconds)
				readings_used = readings_used + 1

				if debug:
					print "Microseconds %1.f" % delta.microseconds

			FIRMATA_PIN_RED_LED.write(0)
			FIRMATA_PIN_GREEN_LED.write(1)


	                # take a little break, it appears to help stabalise readings
	                # I suspect due to less interference with previous readings
	                time.sleep(0.00002)

	        average_reading = sum(reading_list)/len(reading_list)

	        all_readings.append(average_reading)

	FIRMATA_PIN_RED_LED.write(1)
	FIRMATA_PIN_GREEN_LED.write(1)

	average_of_all_readings = sum(all_readings)/len(all_readings)
	average_distance=average_of_all_readings * 340
	average_distance=average_distance/20000
	return_text = "%s cm" % average_distance

	FIRMATA_PIN_RED_LED.write(0)
	FIRMATA_PIN_GREEN_LED.write(0)

	return return_text

def read_arduino_temperature():
	while FIRMATA_PIN_TEMPERATURE.read() is None:
		pass

	temp_pin_read = FIRMATA_PIN_TEMPERATURE.read()
	temp_factored = temp_pin_read * 1024
	per_step = 5000 / 1024 # 5v / 1024 steps = 4.88mV per step
	temp_stepped = temp_factored * per_step
	temp_based = temp_stepped - 500 # 500 is the reference voltage for 0oC
	# fiddle around with it - the + figure on the end is calibration
	temperature_string = temp_based / 10 + 8
	temperature_string = "%1.f oC" % temperature_string

	return temperature_string

############## MENU HANDLER ####################
MENU_KEY = ["IP address", "Onboard temp", "Arduino temp", "Arduino LDR", "Arduino magnet", "Arduino distance"]
def processMenuItem(step):
	# For development, you can lock the function by specifying an override for 'step'
	#step = 5

	if step == 0:
		local_hostname=socket.gethostname()
		for addr in get_ip_addresses():
			send_to_lcd(local_hostname, addr)
			time.sleep(0.5)

	if step == 1:
		reading_text = read_temperature()
		send_to_lcd(MENU_KEY[step], reading_text)

	if step == 2:
		reading_text = read_arduino_temperature()
		send_to_lcd(MENU_KEY[step], reading_text)

	if step == 3:
		llevel="%.1f lux" % (FIRMATA_PIN_LDR.read() * 5 * 100)
		send_to_lcd(MENU_KEY[step], llevel)

	if step == 4:
		magnt="%.1f g" % (FIRMATA_PIN_MAGNET.read() * 5 * 100)
		send_to_lcd(MENU_KEY[step], magnt)

	if step == 5:
		distance_text = read_ultrasonic()
		send_to_lcd(MENU_KEY[step], distance_text)



def main():
	# Main program block
	GPIO.setwarnings(False)
	GPIO.setmode(GPIO.BCM)			 # Use BCM GPIO numbers
	GPIO.setup(LCD_E, GPIO.OUT)	# E
	GPIO.setup(LCD_RS, GPIO.OUT) # RS
	GPIO.setup(LCD_D4, GPIO.OUT) # DB4
	GPIO.setup(LCD_D5, GPIO.OUT) # DB5
	GPIO.setup(LCD_D6, GPIO.OUT) # DB6
	GPIO.setup(LCD_D7, GPIO.OUT) # DB7

	# Initialise display
	lcd_init()
	time.sleep(0.5)

	# header
	send_to_lcd("-=PiPodCorder=-", "Starting up...")
	FIRMATA_PIN_GREEN_LED.write(0)
	FIRMATA_PIN_GREEN_LED.write(1)
	FIRMATA_PIN_RED_LED.write(0)
	FIRMATA_PIN_RED_LED.write(1)
	time.sleep(0.5)
	FIRMATA_PIN_GREEN_LED.write(1)
	FIRMATA_PIN_RED_LED.write(0)
	#lcd_init()

	CURRENT_MENU_KEY=0
	EXIT_KEY_PRESSED=False

	while not EXIT_KEY_PRESSED:
		step_pressed=FIRMATA_PIN_MENU_STEP.read()
		if step_pressed:
			CURRENT_MENU_KEY=CURRENT_MENU_KEY+1
			if CURRENT_MENU_KEY == len(MENU_KEY):
				CURRENT_MENU_KEY=0
		processMenuItem(CURRENT_MENU_KEY)

		EXIT_KEY_PRESSED=FIRMATA_PIN_MENU_EXIT.read()

	send_to_lcd("-====v==v====-", "-= Shutdown =-")

	FIRMATA_BOARD.exit()
	sys.exit(0)

# LCD FUNCTIONS
def send_to_lcd(_line_1, _line_2):
	lcd_byte(LCD_LINE_1, LCD_CMD)
	lcd_string(_line_1)
	print _line_1

	lcd_byte(LCD_LINE_2, LCD_CMD)
	lcd_string(_line_2)
	print _line_2

	time.sleep(1) # 3 second delay

def lcd_init():
	# Initialise display
	lcd_byte(0x33,LCD_CMD)
	lcd_byte(0x32,LCD_CMD)
	lcd_byte(0x28,LCD_CMD)
	lcd_byte(0x0C,LCD_CMD)	
	lcd_byte(0x06,LCD_CMD)
	lcd_byte(0x01,LCD_CMD)	

def lcd_string(message):
	# Send string to display

	message = message.ljust(LCD_WIDTH," ")	

	for i in range(LCD_WIDTH):
		lcd_byte(ord(message[i]),LCD_CHR)
		time.sleep(0.02)

def lcd_byte(bits, mode):
	# Send byte to data pins
	# bits = data
	# mode = True	for character
	#				False for command

	GPIO.output(LCD_RS, mode) # RS

	# High bits
	GPIO.output(LCD_D4, False)
	GPIO.output(LCD_D5, False)
	GPIO.output(LCD_D6, False)
	GPIO.output(LCD_D7, False)
	if bits&0x10==0x10:
		GPIO.output(LCD_D4, True)
	if bits&0x20==0x20:
		GPIO.output(LCD_D5, True)
	if bits&0x40==0x40:
		GPIO.output(LCD_D6, True)
	if bits&0x80==0x80:
		GPIO.output(LCD_D7, True)

	# Toggle 'Enable' pin
	time.sleep(E_DELAY)		
	GPIO.output(LCD_E, True)	
	time.sleep(E_PULSE)
	GPIO.output(LCD_E, False)	
	time.sleep(E_DELAY)			

	# Low bits
	GPIO.output(LCD_D4, False)
	GPIO.output(LCD_D5, False)
	GPIO.output(LCD_D6, False)
	GPIO.output(LCD_D7, False)
	if bits&0x01==0x01:
		GPIO.output(LCD_D4, True)
	if bits&0x02==0x02:
		GPIO.output(LCD_D5, True)
	if bits&0x04==0x04:
		GPIO.output(LCD_D6, True)
	if bits&0x08==0x08:
		GPIO.output(LCD_D7, True)

	# Toggle 'Enable' pin
	time.sleep(E_DELAY)		
	GPIO.output(LCD_E, True)	
	time.sleep(E_PULSE)
	GPIO.output(LCD_E, False)	
	time.sleep(E_DELAY)	 

if __name__ == '__main__':
	main()

