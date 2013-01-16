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

################################
# Switch on/off various parts of the 'corder
################################
ENABLE_TEMPERATURE=True
ENABLE_DISTANCE=False
ENABLE_SERIAL=False
ENABLE_FIRMATA=True

if ENABLE_SERIAL:
	SERIAL = serial.Serial('/dev/ttyACM0', 9600)

# Define Firmata-enabled Arduino
if ENABLE_FIRMATA:
	FIRMATA_BOARD = pyfirmata.Arduino('/dev/ttyACM0')
	it = pyfirmata.util.Iterator(FIRMATA_BOARD)
	it.start()

	# temperature
	FIRMATA_PIN_TEMPERATURE=FIRMATA_BOARD.get_pin('a:0:i')
	# magnetism
	FIRMATA_PIN_MAGNET=FIRMATA_BOARD.get_pin('a:1:i')
	# light
	FIRMATA_PIN_LDR=FIRMATA_BOARD.get_pin('a:2:i')
	# red LED
	FIRMATA_PIN_RED_LED=FIRMATA_BOARD.get_pin('d:10:p')
	# green LED
	FIRMATA_PIN_GREEN_LED=FIRMATA_BOARD.get_pin('d:9:p')

while FIRMATA_PIN_TEMPERATURE.read() is None:
	pass

def get_ip_addresses():
	ips = commands.getoutput("/sbin/ifconfig | grep -i \"inet\" | grep -iv \"inet6\" | " + "awk {'print $2'} | sed -ne 's/addr\:/ /p'")
	addrs = ips.split('\n')
	return addrs

def read_temperature():
	gettemp = sub.Popen(['gpio/tmp102/temperature_read.sh'], stdout=sub.PIPE, stderr=sub.PIPE)
	temp = gettemp.communicate()
	return temp[0]

def read_sonar():
	getdata = sub.Popen(['gpio/ultrasonic/sonar_ping.py'], stdout=sub.PIPE, stderr=sub.PIPE)
	temp = getdata.communicate()
	return temp[0]
def read_arduino():
	SERIAL.flushInput()
	line = SERIAL.readline()
	line = line.rstrip("\n")
	line = line.rstrip("\r")
	return line
	
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

	send_to_lcd("          ", "         ")
	time.sleep(3)
	send_to_lcd("-=====v==v====-", "-=PiPodCorder=-")
	time.sleep(0.5)

	while True:
		lcd_init()

		local_hostname=socket.gethostname()
		for addr in get_ip_addresses():
			send_to_lcd(local_hostname, addr)
			time.sleep(0.5)

		if ENABLE_SERIAL:
			number_of_serial_reads = 3
			for i in range(number_of_serial_reads):
				send_to_lcd('Arduino', read_arduino())

		if ENABLE_TEMPERATURE:
			temperature=read_temperature()
			send_to_lcd('On-plate temp', temperature)
			time.sleep(0.2)
			send_to_lcd('On-plate temp', temperature+".........")

		if ENABLE_DISTANCE:
			for t in range(0,2):
				distance=read_sonar()
				send_to_lcd('Target distance', distance)
				time.sleep(0.2)
				send_to_lcd('Target distance', distance+".....")

		if ENABLE_FIRMATA:
			FIRMATA_PIN_GREEN_LED.write(1.0)

			for i in range(10):
				print "LED at %d %%" % (i*10)
				FIRMATA_PIN_RED_LED.write(i/10.0)
				FIRMATA_PIN_GREEN_LED.write(1-(i/10.0))

				temp="%.1f oC" % (FIRMATA_PIN_TEMPERATURE.read() * 5 * 100)
				send_to_lcd('Arduino temp', temp)

				magnt="%.1f g" % (FIRMATA_PIN_MAGNET.read() * 5 * 100)
				send_to_lcd('Magnetism', magnt)

				llevel="%.1f lux" % (FIRMATA_PIN_LDR.read() * 5 * 100)
				send_to_lcd('Light level', llevel)
			
			FIRMATA_PIN_RED_LED.write(0)
			FIRMATA_PIN_GREEN_LED.write(0)
		time.sleep(1)

	if ENABLE_FIRMATA:
		FIRMATA_BOARD.exit()

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

