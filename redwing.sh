cd /boot/redwing-pi
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
                FNC=$(whiptail --title="REDWING (raspberrypipod.blogspot.com)" --menu "Please note: Some items require other items to be installed before they will work. Please read any on-screen messages." 20 100 12 --ok-button "Go" --cancel-button "Exit" \
			"operating_system" 	"Operating system updates, upgrades and tweaks" \
			"bluetooth"		"Bluetooth connection management" \
			"gpio"			"Wiring and tinkering" \
			"wifi"			"Networking without wires!" \
			"software"		"Lots of things you need for your Pi" \
			"reboot"		"Reboot your Raspberry Pi" \
			"shutdown"		"Shutdown your Raspbeery Pi" \
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
