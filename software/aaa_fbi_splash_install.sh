apt-get install fbi
cp aaasplashscreen /etc/init.d/
cp aaasplash.png /etc/
chmod a+x /etc/init.d/aaasplashscreen
insserv /etc/init.d/aaasplashscreen
echo ""
echo "Now reboot"

