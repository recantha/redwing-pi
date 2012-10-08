#!/bin/bash
SIZE="320x240"
FPS=1
TITLE="Redwing test snapshot"
SUBTITLE="Snapshot from current location"
MONITOR="Active @ $FPS fps"
OUTPUT_FILE="/var/www/snapshot.jpg"
JPEG_COMPRESSION=55
SKIP_FOR_STABILITY=5

clear
echo "Redwing snapshot test"
echo "This script creates an image at $OUTPUT_FILE and updates it every $FPS seconds"
echo "The image size is $SIZE and compression is set to $JPEG_COMPRESSION"
echo "------"
echo "$TITLE - $SUBTITLE - $MONITOR"
echo ""
echo "Press ctrl-c to stop it"

fswebcam -r "$SIZE" -S $SKIP_FOR_STABILITY --jpeg $JPEG_COMPRESSION --shadow --title "$TITLE" --subtitle "$SUBTITLE" --info "$MONITOR" --save "$OUTPUT_FILE" -q -l $FPS

