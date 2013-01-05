#!/bin/bash
clear

echo "Do not install if using Occidentalis as this lot is already installed!"
echo "Press any key to continue install or CTRL-C to abort"
read -n 1 -s NULL

apt-get update
apt-get install python
apt-get install python3-dev

apt-get install python-rpi.gpio
apt-get install python3-rpi.gpio
