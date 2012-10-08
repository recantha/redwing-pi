#!/bin/sh
apt-get install hostapd
apt-get install dnsmasq

echo "Set up wlan0 to come up as a static IP address: /etc/network/interfaces:"
echo "iface wlan0 inet static"
echo "address 10.0.0.1"
echo "netmask 255.255.255.0"
echo ""

echo "Edit /etc/default/hostapd"
echo "DAEMON_CONF=\"/boot/bin/ap_hostapd.conf\""
echo ""

# Sets dhcp range and length of lease
echo "Edit /etc/dnsmasq.conf"
echo "interface=wlan0"
echo "dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h"
echo ""
