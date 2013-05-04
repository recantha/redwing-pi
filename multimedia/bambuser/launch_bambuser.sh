avconv -f video4linux2 -s 160x120 -r 30 -i /dev/video0 -metadata title="Cambridge Raspberry Jam (TEST)" -f flv rtmp://96d68052.fme.bambuser.com/b-fme/6da549f80ff1dfd6271c41ff63247c1f73f21dfa
