#!/bin/bash
clear
echo "Starting PAND"
echo ""
sudo pand -c 00:23:D4:32:5C:88 --role PANU --persist 30
echo ""
echo "Current ifconfig state:"
ifconfig -a
echo ""
echo "Press any key"
read -n1 -s TMP
