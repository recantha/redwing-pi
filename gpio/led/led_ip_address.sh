#!/bin/sh

/boot/bin/pi_led_test.sh 0 0 0 `hostname -I`

if [ "$1" = "0" ];then
	/boot/bin/pi_led_off.sh
	exit 0
else
	/boot/bin/pi_led_ip_address.sh 0
fi
