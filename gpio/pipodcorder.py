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
import subprocess as sub

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

def read_temperature():
	gettemp = sub.Popen(['/boot/redwing-pi/gpio/tmp102/temperature_read.sh'], stdout=sub.PIPE, stderr=sub.PIPE)
	temp = gettemp.communicate()
	return temp[0]

def read_sonar():
	getdata = sub.Popen(['/boot/redwing-pi/gpio/ultrasonic/sonar_ping.py'], stdout=sub.PIPE, stderr=sub.PIPE)
	temp = getdata.communicate()
	return temp[0]

def main():
	# Main program block
	GPIO.setmode(GPIO.BCM)			 # Use BCM GPIO numbers
	GPIO.setup(LCD_E, GPIO.OUT)	# E
	GPIO.setup(LCD_RS, GPIO.OUT) # RS
	GPIO.setup(LCD_D4, GPIO.OUT) # DB4
	GPIO.setup(LCD_D5, GPIO.OUT) # DB5
	GPIO.setup(LCD_D6, GPIO.OUT) # DB6
	GPIO.setup(LCD_D7, GPIO.OUT) # DB7

	# Initialise display

	while True:
		lcd_init()
		time.sleep(1)
		send_to_lcd("-=====v==v====-", "-=PiPodCorder=-")
		time.sleep(0.5)

		local_hostname=socket.gethostname()
		send_to_lcd(local_hostname, socket.gethostbyname(local_hostname))
		for t in range(0,10):
			temperature=read_temperature()
			send_to_lcd('Room temperature', temperature)
			time.sleep(0.2)
			send_to_lcd('Room temperature', temperature+".........")

		for t in range(0,2):
			distance=read_sonar()
			send_to_lcd('Target distance', distance)
			time.sleep(0.2)
			send_to_lcd('Target distance', distance+".....")


		time.sleep(1)

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
