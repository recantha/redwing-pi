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
                FNC=$(whiptail --title="REDWING (raspberrypipod.blogspot.com)" --menu "Installation and integration for Wireless networks" 20 100 12 --ok-button "Go" --cancel-button "Exit" \
			"wicd_install"		"[optional] Install WICD text-GUI for wifi" \
			"dhcpd_install"		"Install DHCPD" \
			"zd1211_install.sh"	"Install firmware for ZD1211 wifi dongles" \
			"wpa_supplicant_helper"	"Get help setting up Wifi connection" \
			"load_wpa_conf"		"Use wpa_supplicant and your 'helper' config to start the Wifi connection" \
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
