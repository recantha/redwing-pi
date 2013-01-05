#!/bin/bash

hexraw=$(echo "")
while [ "$hexraw" == "" ];do
	hexraw=$(i2cget -y 1 0x48)
done

printf "Temperature (to nearest degree): %d\n" "$hexraw"

msb=$(echo ${hexraw:4:2})
lsb=$(echo ${hexraw:2:1})

echo $msb
echo $lsb

dec=$(printf "%d\n" "0x$msb$lsb")
echo $dec
temperature=`echo "scale=2; $dec*0.0625" | bc`
printf "$temperature\n"
