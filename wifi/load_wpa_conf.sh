#!/bin/bash
CONFFILE=$1
killall wpa_supplicant
wpa_supplicant -Dwext -iwlan0 -c $CONFFILE -B

