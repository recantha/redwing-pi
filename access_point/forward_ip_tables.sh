iptables -A FORWARD -i wlan1 -o wlan0 -s 10.0.0.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
