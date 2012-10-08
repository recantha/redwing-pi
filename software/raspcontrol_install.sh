#!/bin/sh

# Configure your paths here
INSTALL_PATH=/var/www/raspcontrol
VERSIONS_PATH=$INSTALL_PATH/versions
LOG_PATH=$VERSIONS_PATH/install.log
SOURCE_URL=https://github.com/Bioshox/Raspcontrol/zipball/master
EXTRACTED_DIR_PREFIX=Bioshox


# SCRIPT STARTS HERE
echo "---" > $LOG_PATH
echo "Raspcontrol Installation started at" `date`\n >> $LOG_PATH
echo "----- Raspcontrol Installer -----"
echo Installing raspcontrol to $INSTALL_PATH
echo Versions kept at $VERSIONS_PATH
echo Installation log at $LOG_PATH
echo Ensuring all paths exist...

# Split path into bits and recursively make sure they exist
A_PATH=$(echo $VERSIONS_PATH | tr "/" "\n")

CURPATH=""
for PART in $A_PATH
do
	CURPATH=$CURPATH/$PART
	[ -d $CURPATH ] && sleep 0 || mkdir $CURPATH
done

# Download Raspcontrol, then keep this version as an archive so you can roll back if you want
echo "Downloading Raspcontrol from Github"
cd $VERSIONS_PATH
VERSION_DATE_FILE=`date +%Y%m%d`_raspcontrol.zip
echo "This version will be kept at" $VERSION_DATE_FILE
echo "wgetting the source to" $VERSION_DATE_FILE \n >> $LOG_PATH
wget $SOURCE_URL -O $VERSION_DATE_FILE >> $LOG_PATH 2>&1

echo "unzipping...\n" >> $LOG_PATH
# Make sure there isn't already one there
rm -rf Biosh*
unzip $VERSION_DATE_FILE >> $LOG_PATH 2>&1

CURRENT_FOLDER=`ls | grep $EXTRACTED_DIR_PREFIX`
rm -rf /tmp/versions
mv $VERSIONS_PATH /tmp/versions
rm -rf $INSTALL_PATH/*
mv /tmp/versions $VERSIONS_PATH
mv $VERSIONS_PATH/$CURRENT_FOLDER/* $INSTALL_PATH/
echo "Moved the new version to the installation path"

echo "Cleaning up"
rm -rf $VERSIONS_PATH/$CURRENT_FOLDER

echo "All done"

