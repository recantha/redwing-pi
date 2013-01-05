#!/usr/bin/python

import pyfirmata

board = pyfirmata.Arduino('/dev/ttyACM0')

it = pyfirmata.util.Iterator(board)
it.start()

pin11=board.get_pin('d:11:p')

pin11.write(1.0)
board.pass_time(0.5)
pin11.write(0.5)
board.pass_time(0.5)
pin11.write(0)

board.exit()
