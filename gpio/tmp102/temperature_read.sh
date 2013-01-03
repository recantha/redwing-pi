#!/bin/bash

hexraw=$(echo "")
while [ "$hexraw" == "" ];do
	hexraw=$(i2cget -y 1 0x48 0x00 w)
done


msb=$(echo ${hexraw:4:2})
lsb=$(echo ${hexraw:2:1})

dec=$(printf "%d\n" "0x$msb$lsb")
temperature=`echo "scale=2; $dec*0.0625-10" | bc`
printf "$temperature"
