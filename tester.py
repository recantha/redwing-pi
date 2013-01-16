#!/usr/bin/python

import pyfirmata

board = pyfirmata.Arduino('/dev/ttyACM0')
it = pyfirmata.util.Iterator(board)
it.start()

# temperature
pinA0=board.get_pin('a:0:i')
# magnetism
pinA1=board.get_pin('a:1:i')
# light
pinA2=board.get_pin('a:2:i')
# red LED
pinD10=board.get_pin('d:10:p')
# green LED
pinD9=board.get_pin('d:9:p')

while pinA0.read() is None:
	pass

pinD9.write(1.0)

for i in range(10):
	print "LED at %d %%" % (i*10)
	pinD10.write(i/10.0)
	pinD9.write(1-(i/10.0))

	print "Temperature %.1f oC" % (pinA0.read() * 5 * 100)
	print "Magnetism %.1f" % (pinA1.read() * 5 * 100)
	print "Light level %.1f" % (pinA2.read() * 5 * 100)
	board.pass_time(1)

pinD10.write(0)
pinD9.write(0)
board.exit()
