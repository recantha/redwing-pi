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
                FNC=$(whiptail --title="REDWING (raspberrypipod.blogspot.com)" --menu "Software" 20 100 12 --ok-button "Go" --cancel-button "Exit" \
			"apache_and_php_install" 	"Install Apache and PHP to put a website on your Pi" \
			"lynx_install"			"Install text-based web browser" \
			"raspcontrol_install"		"Install Raspcontrol - a web-based system information console" \
			"raspcontrol_start"		"Start up Raspcontrol" \
			"samba_install"			"Install Samba so your Pi can be seen on a Windows network" \
			"screen_install"		"[Advanced] Install Screen to allow multiple connections to a single console" \
			"screen_integrate"		"[Advanced] Integrate Screen into logins and profiles" \
			"vnc_install"			"Install VNC for remote desktop" \
			"vnc_start"			"Start VNC up for the first time and set-up configs" \
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
