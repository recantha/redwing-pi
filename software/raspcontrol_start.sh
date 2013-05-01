#!/bin/sh
killall php > /dev/null 2>&1
killall apache2 > /dev/null 2>&1
killall apache > /dev/null 2>&1
cd /var/www/raspcontrol
screen -d -m /var/www/raspcontrol/start.sh
