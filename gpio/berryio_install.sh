#!/bin/bash
mkdir /tmp/berryio
cd /tmp/berryio
wget http://frozenmist.co.uk/downloads/berryio/download/berryio_1.4.0.tar.gz
tar -xvzf berryio_1.4.0.tar.gz
cd berry*
more INSTALL.README.txt

clear
echo "We will now install BerryIO using the instructions in the README you just read... All the way through, I'm sure!"

# Make sure your distribution is up to date
apt-get update
apt-get upgrade

# Run the installation script
./install.sh

# Configure the email addresses you wish BerryIO to use
nano /etc/berryio/email.php

# Configure msmtp so it can access your mailserver
# Please check http://msmtp.sourceforge.net/documentation.html
# for further details
nano /etc/msmtprc

# Test BerryIO is working
berryio help

# Test email is working
berryio email_ip
