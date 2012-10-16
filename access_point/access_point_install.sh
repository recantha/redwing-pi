#!/bin/bash
clear

echo "Redwing Access Point installer"
echo "(c) Michael Horne 2012 / Recantha"
echo "Please note all responses requested are Case Sensitive"
echo ""
echo "SPECIFY WIRELESS DEVICE"


# DEBUGGING MODE - set to something other than hostapd.conf
HOSTAPDFILE=hostapd.conf


# List devices
iwconfig 2>/dev/null | grep wlan
echo "Please type in the name of the wlan device to use as the access point"
read WLAN

echo "Type in the name of the wifi driver. This is normally nl80211 but may vary. You can always change this later by modifying the hostapd.conf file"
read DRIVER

echo "Type in the name of the access point you wish to create"
read SSID

echo "Type in the passphrase for the access point"
read PASSPHRASE

echo "PACKAGE INSTALLATION"
echo "There are a fair few packages that need to be installed. Some of these may require you to confirm their installation"
echo "Press any key"
read -n1 -s IGNORE

apt-get update
apt-get install hostapd
apt-get install dnsmasq
apt-get install dhcpd
apt-get install wireless-tools hostapd bridge-utils

echo ""
echo "Using $WLAN for the access point"
echo ""

# HOSTAPD SECTION
echo "Generating the hostapd.conf file"

# Create the hostapd.conf file
echo "" > $HOSTAPDFILE
echo "interface=$WLAN" >> $HOSTAPDFILE
echo "driver=$DRIVER" >> $HOSTAPDFILE
echo "ctrl_interface=/var/run/hostapd" >> $HOSTAPDFILE
echo "ctrl_interface_group=0" >> $HOSTAPDFILE
echo "ssid=$SSID" >> $HOSTAPDFILE
echo "hw_mode=g" >> $HOSTAPDFILE
echo "channel=10" >> $HOSTAPDFILE
echo "wpa=3" >> $HOSTAPDFILE
echo "wpa_passphrase=$PASSPHRASE" >> $HOSTAPDFILE
echo "wpa_key_mgmt=WPA-PSK" >> $HOSTAPDFILE
echo "wpa_pairwise=TKIP" >> $HOSTAPDFILE
echo "rsn_pairwise=CCMP" >> $HOSTAPDFILE
echo "beacon_int=100" >> $HOSTAPDFILE
echo "auth_algs=3" >> $HOSTAPDFILE
echo "wmm_enabled=1" >> $HOSTAPDFILE
echo "" >> $HOSTAPDFILE

echo ""
echo "Do you want to change the system so it uses the hostpad.conf file just generated? (Do this ONCE and ONCE only)"
read -n1 -s CONFIRM
if [ "$CONFIRM" == "Y" ];then
	echo "DAEMON_CONF=\"/boot/redwing-pi/access_point/hostapd.conf\"" >> /etc/default/hostapd
fi

echo "Do you want to route the IP tables for network forwarding? [Y to do it]"
read -n1 -s CONFIRM
if [ "$CONFIRM" == "Y" ];then
   iptables -A FORWARD -i $WLAN -o wlan0 -s 10.0.0.0/24 -m state --state NEW -j ACCEPT
   iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
   iptables -A POSTROUTING -t nat -j MASQUERADE
   sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
fi

echo "Do you want to set /etc/network/interfaces for the access point (wlan3)? (Do this ONCE and only ONCE) [Y to do it]"
read -n1 -s CONFIRM
if [ "$CONFIRM" == "Y" ];then
   echo "" >> /etc/network/interfaces
   echo "auto $WLAN" >> /etc/network/interfaces
   echo "iface $WLAN inet static" >> /etc/network/interfaces
   echo "      address 10.0.0.1" >> /etc/network/interfaces
   echo "      netmask 255.255.255.0" >> /etc/network/interfaces
   echo "      wireless-channel 10" >> /etc/network/interfaces
   echo "      wireless-ssid \"$SSID\"" >> /etc/network/interfaces
   echo "      wireless-mode ad-hoc" >> /etc/network/interfaces
   echo "" >> /etc/network/interfaces

   echo ""
   echo "NB: If you have run this twice, you will need to remove the duplicate text"
   echo "NB: If your wifi dongle for the access point is NOT on wlan3, edit /etc/network/interfaces to suit"
fi

# Sets dhcp range and length of lease
echo "MANUAL PROCESSES REQUIRED"
echo "Edit /etc/dnsmasq.conf"
echo "Find and change interface setting to : interface=$WLAN"
echo "dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h"
echo ""

