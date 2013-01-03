apt-get update
apt-get install python-smbus
adduser pi i2c

echo "Now edit /etc/modprobe.d/raspi-blacklist.conf and comment out i2c"
echo "And edit /etc/modules and add i2c-dev on the last line"
echo "And reboot"
