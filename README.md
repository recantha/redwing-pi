redwing-pi
==========

These are a set of scripts to set up my Raspberry Pi and to carry out experiments with wifi, bluetooth and sensors.
The current project using these scripts is called the PiPodCorder.

See my blog at http://www.recantha.co.uk/blog for more details.

The current groups of scripts are as follows:
* access_point - turn the Raspberry Pi into a wifi access point
	(I'm using this to tether a mobile phone to it so I can access the Pi from a VNC session running on the phone. But, the same principle applies for running it as a wifi router)
* bluetooth - connect devices over bluetooth to the Pi
	(I'm using this primarily to connect a Rii Bluetooth Keyboard/Trackpad)
* gpio - various scripts and modules to use the GPIO pins
	(Other scripts in there include: LCD control for a 16x2 display, LED on/off simple script, read from a TMP102 temperature sensor, read from an SR04 Ultrasonic distance sensor)
* multimedia - scripts to activate and use a webcam, including motion-detection
* operating_system - update and upgrade your Pi with ease
* software - various installation scripts for software packages and projects that run on the Pi
* wifi - scripts to help you get your Pi running on a wifi network (for instance to run it 'headless')

The menu system (which is not always up-to-date) can be used by running ./redwing.sh in the top folder.

Some of these scripts are incomplete, some of them only work for the purpose I was aiming at at the time. But I hope it's of use to someone somewhere who is just starting out with the Pi and wants to move on to some of the cooler things it can do.

You can contact me at mike@recantha.co.uk or on my blog if you have any questions or problems getting the scripts to run or do what you want them to do.
