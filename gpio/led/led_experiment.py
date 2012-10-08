import RPi.GPIO as GPIO

GPIO.setup(11, GPIO.IN)
GPIO.setup(12, GPIO.OUT)

input_value = GPIO.input(11)

GPIO.output(12, True)

