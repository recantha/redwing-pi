/usr/bin/gst-launch-0.10 -v --gst-plugin-path=/usr/lib/arm-linux/gnueabihf/gstreamer-0.10/gstreamer-0.10 v4l2src videorate ffmpegcolorspace queue2 flvmux name=mux queue2 max-size-buffers=600 max-size-bytes=0 max-size-time=0 audioconvert mux. mux. queue2 filesink location=/tmp/outfile.flv sync=false
#/usr/bin/gst-launch-0.10 -v -v --gst-plugin-path=/usr/local/lib/gstreamer-0.10 v4l2src videorate ffmpegcolorspace queue2 flvmux name=mux queue2 max-size-buffers=600 max-size-bytes=0 max-size-time=0 audioconvert mux. mux. queue2 filesink location=/tmp/outfile.flv sync=false &

#/usr/include/gstreamer-0.10
#/usr/lib/arm-linux-gnueabihf/gstreamer-0.10
#/usr/lib/arm-linux-gnueabihf/gstreamer0.10/gstreamer-0.10
#/usr/share/gstreamer-0.10
