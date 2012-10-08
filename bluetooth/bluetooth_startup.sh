#!/bin/sh
/etc/init.d/bluetooth stop
/etc/init.d/bluetooth start
hciconfig hci0 down
hciconfig hci0 up
hciconfig -a

