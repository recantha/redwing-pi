#!/bin/bash
 
# A very crude script to setup samba inspired by MrEngmans Realtek RTL8188CUS script
# V1.1 - added in apt-get update
# http://cymplecy.wordpress.com/2012/08/09/auto-install-a-simple-samba-setup/ 

echo
echo "This script will install Samba (windows networking) in a very simple manner"
echo " "
echo "It only requires the name you wish to call your RaspberryPi and you aslo have to type in a password"
echo "I really recommend using raspberry as the password as I know everything will work properly then"
echo " "
read -p "Press any key to continue..." -n1 -s
echo
echo
 
    while true; do
        echo
        read -p "Please enter the name you wish to give your RaspberryPi - " RPINAME
        echo
        echo "You have named your RaspberryPi as \"$RPINAME\", is that correct?"
        read -p "press Y to continue, any other key to re-enter the name. " -n1 RESPONSE
        if [ "$RESPONSE" == "Y" ] || [ "$RESPONSE" == "y" ]; then
            echo
            break
        fi
        echo
    done
apt-get update
apt-get install --force-yes samba
apt-get install --force-yes samba-common-bin
smbpasswd -a pi
echo "#======================= Global Settings =======================" > /etc/samba/smb.conf
echo "[global]" >> /etc/samba/smb.conf
echo "workgroup = WORKGROUP" >> /etc/samba/smb.conf
echo "server string = " $RPINAME " server" >> /etc/samba/smb.conf
echo "netbios name = " $RPINAME >> /etc/samba/smb.conf
 
echo "dns proxy = no" >> /etc/samba/smb.conf
 
echo "#### Debugging/Accounting ####" >> /etc/samba/smb.conf
echo "log file = /var/log/samba/log.%m" >> /etc/samba/smb.conf
echo "max log size = 1000" >> /etc/samba/smb.conf
echo "syslog = 0" >> /etc/samba/smb.conf
echo "panic action = /usr/share/samba/panic-action %d" >> /etc/samba/smb.conf
 
echo "####### Authentication #######" >> /etc/samba/smb.conf
echo "security = user" >> /etc/samba/smb.conf
echo "map to guest = pi" >> /etc/samba/smb.conf
 
echo "#======================= Share Definitions =======================" >> /etc/samba/smb.conf
echo "[homes]" >> /etc/samba/smb.conf
 
echo "comment = Home Directories" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "guest ok = yes" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf
echo "create mask = 0775" >> /etc/samba/smb.conf
echo "directory mask = 0775" >> /etc/samba/smb.conf
echo "writeable = yes" >> /etc/samba/smb.conf
echo "guest account = pi" >> /etc/samba/smb.conf
 
echo "[public]" >> /etc/samba/smb.conf
echo "path = /" >> /etc/samba/smb.conf
echo "guest ok = yes" >> /etc/samba/smb.conf
echo "guest account = ftp" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf
echo "create mask = 0777" >> /etc/samba/smb.conf
echo "directory mask = 0777" >> /etc/samba/smb.conf
echo "writeable = yes" >> /etc/samba/smb.conf
echo "admin users = everyone" >> /etc/samba/smb.conf
 
echo "[boot]" >> /etc/samba/smb.conf
echo "path = /boot" >> /etc/samba/smb.conf
echo "guest ok = yes" >> /etc/samba/smb.conf
echo "guest account = ftp" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf
echo "create mask = 0777" >> /etc/samba/smb.conf
echo "directory mask = 0777" >> /etc/samba/smb.conf
echo "writeable = yes" >> /etc/samba/smb.conf
echo "admin users = everyone" >> /etc/samba/smb.conf
 
/etc/init.d/samba restart
 
 
# time to finish!
 
echo
echo
echo "Have fun with " $RPINAME"
echo
echo "Remember to logon as user=pi password=raspberry from your windows machines
echo
