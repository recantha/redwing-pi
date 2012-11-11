/usr/bin/ffmpeg -y -re -i /tmp/outfile.flv -s 320x240 \
  -vcodec flv -b 152k -g 150 -cmp 2 -subcmp 2 -mbd 2 \
  -f flv rtmp://5719.fme.bambuser.com/b-fme/6da549f80ff1dfd6271c41ff63247c1f73f21dfa


