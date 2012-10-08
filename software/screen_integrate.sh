OUT_FILE=/etc/profile

echo "" >> $OUT_FILE
echo "if [ -n \"\$PS1\" ] && [ -z \"\$STARTED_SCREEN\" ] && [ -z \"\$SSH_TTY\" ];then" >> $OUT_FILE
echo "  echo \`date\` >> ~/.screen.log" >> $OUT_FILE
echo "  echo \`tty\` >> ~/.screen.log" >> $OUT_FILE
echo "  echo \"\$SSH_TTY\" >> ~/.screen.log" >> $OUT_FILE
echo "  STARTED_SCREEN=1;" >> $OUT_FILE
echo "  export STARTED_SCREEN;" >> $OUT_FILE
echo "" >> $OUT_FILE
echo "  screen -m" >> $OUT_FILE
echo "  exit 0" >> $OUT_FILE
echo "fi" >> $OUT_FILE

clear
echo "Have added lines to /etc/profile"
echo ""
echo "Now you need to MANUALLY change /etc/inittab"
echo "Add a '#' to the start of the line 1:2345:respawn"
echo "Then add"
echo "1:2345:respawn:/bin/login -f pi tty1 </dev/tty1 > /dev/tty1 2>&1"
echo ""
