 #!/bin/sh -f
mknod /dev/vhci c 10 250
chmod 664 /dev/vhci
  
C=0;
while [ $C -lt 256 ]; do
	if [ ! -c /dev/rfcomm$C ]; then
		mknod -m 666 /dev/rfcomm$C c 216 $C
	fi
	C=`expr $C + 1`
done
