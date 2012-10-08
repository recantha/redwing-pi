OUT_FILE=/etc/profile

echo "Adding rii_connect script to /etc/profile"
echo "" >> $OUT_FILE
echo "if [ -n \"\$PS1\" ] && [ -z \"\$STARTED_SCREEN\" ] && [ -z \"\$SSH_TTY\" ];then" >> $OUT_FILE
echo "  MY_TTY=\`tty\`" >> $OUT_FILE
echo "  if [ \"\$MY_TTY\" = \"/dev/tty1\" ]; then" >> $OUT_FILE
echo "	sudo /boot/redwing/bluetooth/rii_connect.sh >/dev/null 2>&1 &" >> $OUT_FILE
echo "  fi" >> $OUT_FILE
echo "fi" >> $OUT_FILE
echo "All done"
