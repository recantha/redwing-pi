clear
echo fswebcam allows you to take simple snapshots from a webcam
echo Do you want to continue?
read -n 1 -s OKAY
echo $OKAY
if [ "$OKAY" = "Y" ]; then
	apt-get install fswebcam
	mkdir /var/www/motion
fi
