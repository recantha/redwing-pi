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
                FNC=$(whiptail --title="REDWING : OS utilities" --menu "Install and run OS scripts to improve your set-up" 20 100 12 --ok-button "Run" --cancel-button "Cancel" \
			"cpu_info"				"Show info about the Pi's CPU" \
			"apt_update_and_upgrade" 		"Run apt-get update and upgrade" \
			"hexxeh_firmware_updater_install" 	"Install the Hexxeh Firmware Updater" \
			"hexxeh_firmware_updater_run" 			"Run Hexxeh's Firmware Updater" \
			"increase_history" 			"Increase number of commands stored in history" \
			"set_large_font" 			"Increase font size" \
			"speed_up_boot" 			"Speed up the boot speed of the Raspberry Pi" \
			"firmware_headers_install" 		"[Advanced] Install firmware headers (used for compiling)" \
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
