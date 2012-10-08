#!/bin/bash
ifconfig $1 up 10.0.0.1 netmask 255.255.255.0
dhcpd $1 &

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $2 -j MASQUERADE
iptables --append FORWARD --in-interface $1 -j ACCEPT
sysctl -w net.ipv4.ip_forward=1
#start hostapd
hostapd /boot/bin/hostapd.conf 1>/dev/null


