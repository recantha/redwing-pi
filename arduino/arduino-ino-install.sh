# Need this for the board definitions, even though it's massive
apt-get install arduino-mk

# Terminal software used for 'ino serial'
apt-get install picocom

# Installs various things including easy_install
apt-get install python-pip

# Various packages necessary for ino execution, and then ino itself
easy_install configobj
easy_install jinja2
easy_install ino

echo "You can use ino by creating a folder, going into it and then typing 'ino init'"
echo "Building the code is done via 'ino build' and then upload is 'ino upload'"
echo "Monitoring of the serial port comms is done via 'ino serial'"




