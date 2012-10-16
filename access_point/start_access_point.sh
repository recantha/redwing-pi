#!/bin/bash
killall hostapd
clear

USAGE="Usage: start_access_point <wlan> <device>        Where <wlan> is your access point wlan dongle and <device> is the working internet connection you want to bridge to (if it exists, otherwise just use eth0)"
if [ "$1" == "" ];then
	echo $USAGE
	exit 0
fi

if [ "$2" == "" ];then
	echo $USAGE
	exit 0
fi

ifconfig $1 up 10.0.0.1 netmask 255.255.255.0
udhcpd $1 &

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $2 -j MASQUERADE
iptables --append FORWARD --in-interface $1 -j ACCEPT
sysctl -w net.ipv4.ip_forward=1

# Now actually start hostapd
hostapd /boot/redwing-pi/access_point/hostapd.conf
# 1>/dev/null


