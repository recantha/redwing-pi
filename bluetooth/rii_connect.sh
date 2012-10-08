#!/bin/bash
clear

service bluetooth restart

BT_ADDRESS="DC:2C:26:D9:1A:BB"
MAX_ATTEMPTS=5

CONNECTION_ATTEMPTED=0
CONNECTION_ATTEMPT_COUNT=0


if [ "$2" != "" ];then
	MAX_ATTEMPTS=$2
fi

echo "***************************"
echo "Bluetooth connection helper"
echo "***************************"
echo "Attempting connection to $BT_ADDRESS. Max $MAX_ATTEMPTS attempt(s)"

if [ "$1" = "restart" ];then
	echo "Restarting bluetooth"
	service bluetooth restart
fi

while (sleep 3);do
	echo ""

	CHECK_EXISTING=`hcitool con | grep $BT_ADDRESS`
	if [ "$CHECK_EXISTING" != "" ];then
		if [ $CONNECTION_ATTEMPTED -eq 0 ];then
			echo "$BT_ADDRESS is already connected"
			exit 2
		else
			echo "Connection was successful!"
			exit 0
		fi
	fi

	let CONNECTION_ATTEMPT_COUNT=CONNECTION_ATTEMPT_COUNT+1
	echo "Connection attempt $CONNECTION_ATTEMPT_COUNT started..."
	SCAN=`hcitool scan | grep $BT_ADDRESS`
	echo "Scanning for $BT_ADDRESS"

	if [ "$SCAN" = "" ]; then
		echo "Did not find $BT_ADDRESS during scan."
	else
		CONNECTION_ATTEMPTED=1
		echo "Device $BT_ADDRESS found"
		sudo hidd --connect $BT_ADDRESS

		echo "Connection attempt finished. Checking for connection the first time"
		CHECK_EXISTING=`hcitool con | grep $BT_ADDRESS`
		if [ "$CHECK_EXISTING" = "" ];then
			echo "Connection failed. Please check your device is in 'discoverable' mode"
		else
			echo "First connection check passed"
		fi
	fi

	if [ $CONNECTION_ATTEMPT_COUNT -eq $MAX_ATTEMPTS ];then
		echo "Failed to connect to $BT_ADDRESS after $MAX_ATTEMPTS attempts"
		exit 2
	else
		if [ $CONNECTION_ATTEMPTED -eq 0 ];then
			echo "Trying again after a short pause..."
		else
			echo "Checking to ensure still connected after a short pause..."
		fi
	fi
done
echo "**********************************"

