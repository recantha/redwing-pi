#!/bin/bash
killall hostapd
clear

USAGE="Usage: start_access_point <wlan> <essid> <bridge_to>"
if [ "$1" == "" ];then
	echo $USAGE
	exit 0
fi

if [ "$2" == "" ];then
	echo $USAGE
	exit 0
fi


if [ "$3" == "" ];then
	echo $USAGE
	exit 0
fi

WLAN=$1
ESSID=2
BRIDGETO=$3

ifconfig $WLAN down
iwconfig $WLAN mode ad-hoc
ifconfig $WLAN up
iwconfig $WLAN essid "$ESSID"
ifconfig $WLAN inet 10.0.0.1


ifconfig $WLAN up 10.0.0.1 netmask 255.255.255.0
udhcpd $WLAN &

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $BRIDGETO -j MASQUERADE
iptables --append FORWARD --in-interface $WLAN -j ACCEPT
sysctl -w net.ipv4.ip_forward=1

# Now actually start hostapd
hostapd /boot/redwing-pi/access_point/hostapd.conf
#hostapd /boot/redwing-pi/access_point/hostapd.conf 1> /dev/null &

