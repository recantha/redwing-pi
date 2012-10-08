echo "Set up an automated task to blink you IP address on the green LED"
echo ""
echo "Manually add"
echo "*/5 * * *	root	/boot/bin/led_ip_address.sh"
echo "to /etc/crontab"
echo ""

ln -s /boot/bin/led_ip_address.sh /etc/init.d/pi_led_ip_address.sh
update-rc.d led_ip_address.sh defaults"

