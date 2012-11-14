INSTRUCTIONS FOR REDWING ACCESS POINT
Please read all the way through

Start with access_point_install.sh
The network will be created with IP address ranges in the 10.0.0.0 range.
To start the access point, run start_access_point.sh. It requires parameters on the command line. The script go_access_point.sh gives you an example of how to automate this.

Please note: when I set this up, wlan3 is my AP dongle. wlan0 is my NORMAL dongle. So, I bridge between wlan3 and wlan0.
You may have to edit some files to get it to work if your AP dongle or NORMAL dongle are on different device names.
I call my access point 'pipod', so you might have to change that too.