fn_run() {
        CHOICE=$1
        CMD=$CHOICE'.sh'
        FINDSCRIPT=`ls | grep $CMD`

        if [ "$FINDSCRIPT" = "$CMD" ];then
                ./$CMD
        else
                FINDFOLDER=`ls | grep $CHOICE`
                if [ "$FINDFOLDER" = "" ];then
                        echo "Script or folder "$CHOICE" not found"
                        sleep 3
                        exit 0
                else
                        cd $CHOICE && ./redwing.sh && cd ..
                fi
        fi
}

main() { 
	while true; do
                FNC=$(whiptail --title="REDWING (raspberrypipod.blogspot.com)" --menu "Bluetooth functionality" 20 100 12 --ok-button "Go" --cancel-button "Exit" \
			"install_bluetooth_packages"		"Install core packages for bluetooth" \
			"bluetooth_startup"			"(Re-)start Bluetooth services" \
			"rii_connect"				"Try to connect to a Rii keyboard" \
			"rii_disconnect"			"Disconnect from the Rii keyboard" \
			"get_connection_pin"			"Run script to get PIN for bluetooth connections" \
			"integrate_rii_connection"		"Auto-run the Rii connection script on login" \
			"rfcomm_devices_create"			"[Advanced] Create RFCOMM devices" \
                3>&1 1>&2 2>&3 \
                )

                RET=$?

		if [ $RET -eq 0 ];then
			fn_run $FNC
		else
			break
		fi
        done
}

main
