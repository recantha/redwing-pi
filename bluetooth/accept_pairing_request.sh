#!/bin/bash
clear
echo "Showing Pi on BT searches..."
./make_pi_visible.sh
echo "Trying to start BT agent with pin 1234 for pairing"
bluetooth-agent 1234 &
echo ""
echo "Press enter to exit"
read -n1 -s TMP

