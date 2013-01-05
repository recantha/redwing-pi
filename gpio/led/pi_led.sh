#!/bin/bash

echo "******************"
echo "Mike's LED Flasher"
echo "******************"

sleep 2

SYNTAX="Syntax: pi_led.sh <duration of tests> <short flash duration in ms> <long flash duration in ms> [<dotted number sequence>]"

nano_sleep() {
	# Approx loop tick per second
	LOOP_COUNT_PER_SECOND=850

	# Divide milliseconds argument to get number of seconds
	let SLEEP_DURATION=$1/1000

	# Determine how many ticks
	let SLEEP_LOOP_MAX=SLEEP_DURATION*LOOP_COUNT_PER_SECOND
	
#	COUNTER=0
#	while [ $COUNTER != $SLEEP_LOOP_MAX ];do
#		let COUNTER=COUNTER+1
#	done

	let SLEEP_DURATION=$1/1000
	sleep $SLEEP_DURATION
}


flash_led() {
	# FLASH_DUR is in milliseconds
	FLASH_DUR=$1
	echo 1 > /sys/class/leds/led0/brightness
	nano_sleep $FLASH_DUR
	echo 0 > /sys/class/leds/led0/brightness
}

end_of_sequence_flash() {
	sleep 2
	flash_led 4000
	echo 0 > /sys/class/leds/led0/brightness
	sleep 2
	echo 0 > /sys/class/leds/led0/brightness

}

# Check arguments
if [ "$1" = "" -o "$2" = "" -o "$3" = "" ];then
	echo "One or more arguments not given"
	echo $SYNTAX
	exit 2
else
	TESTS_DURATION=$1
	SHORT_DURATION=$2
	LONG_DURATION=$3
	SEQUENCE=$4
fi

# Deactivate current trigger for the green LED
echo none > /sys/class/leds/led0/trigger
echo "Current triggers deactivated"

if [ $TESTS_DURATION -gt 0 ];then
	# Flash on for $TESTS_DURATION seconds
	echo "On for $TESTS_DURATION seconds"
	echo 1 > /sys/class/leds/led0/brightness
	sleep $TESTS_DURATION
	echo "Off and wait for $TESTS_DURATION seconds"
	echo 0 > /sys/class/leds/led0/brightness
	sleep $TESTS_DURATION

	# Heartbeat flasher
	echo "Installing heartbeat and initialising for $TESTS_DURATION seconds"
	modprobe ledtrig_heartbeat
	echo heartbeat > /sys/class/leds/led0/trigger

	sleep $TESTS_DURATION

	# Turn off heartbeat
	modprobe -r ledtrig_heartbeat
	echo "Heartbeat off"
fi

if [ "$SEQUENCE" = "" ];then
# Wait for user input
echo "Now ready for manual control"
echo "'a' for $SHORT_DURATION ms flash. 's' for $LONG_DURATION ms flash. 'q' to quit."



CONTINUE=1
while [ $CONTINUE = 1 ];do
	read -n 1 -s keypress
	
	if [ "$keypress" = 'q' ];then
		let CONTINUE=0
	else
		if [ "$keypress" = "a" ];then
			DURATION=$SHORT_DURATION
		elif [ "$keypress" = "b" ];then
			DURATION=$LONG_DURATION
		else
			DURATION=0
		fi


		if [ $DURATION -gt 0 ];then
			flash_led $DURATION
		else
			echo $keypress does nothing
		fi
	fi
done

else
	# do the sequence
	end_of_sequence_flash
	for GROUP in `echo $SEQUENCE | grep -o -e "[^.]*"`;do
		# e.g. GROUP is now 192
		for SINGLE in `echo $GROUP | grep -o -e .`; do
			# SINGLE is now 1 then 9 then 2
			TMP=0
			while [ $TMP != $SINGLE ];do
				let TMP=TMP+1
				flash_led 500
				sleep 0.3
			done
			sleep 1
                done
		sleep 0.8
	done

	end_of_sequence_flash
fi

echo mmc0 > /sys/class/leds/led0/trigger

