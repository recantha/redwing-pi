#!/bin/sh
BT_ADDRESS="DC:2C:26:D9:1A:BB"
DISCONNECTION_HAPPENED=0

while (sleep 3)
do
	CHECK_EXISTING=`hcitool con | grep $BT_ADDRESS`
	if [ "$CHECK_EXISTING" = "" ];then
		if [ $DISCONNECTION_HAPPENED = 0 ];then
			echo "$BT_ADDRESS is not connected at the moment"
			exit 2
		else
			echo "$BT_ADDRESS is disconnected"
			exit 0
		fi
	else
		hcitool dc $BT_ADDRESS
		DISCONNECTION_HAPPENED=1
	fi
done
