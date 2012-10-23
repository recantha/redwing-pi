#!/bin/bash
clear
echo "Showing paired devices"
echo "----------------------"

bluez-test-device list
echo ""
echo "Press enter to exit"
read -n1 -s TMP

