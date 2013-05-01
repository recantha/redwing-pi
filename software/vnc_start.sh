killall Xtightvnc
rm -rf /tmp/.X*

/usr/bin/vncserver :1 -geometry 1024x768 -depth 16 -pixelformat rgb565 -fp /usr/share/fonts/X11/misc
