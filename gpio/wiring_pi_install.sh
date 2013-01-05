rm -rf /tmp/wiringPi
mkdir /tmp/wiringPi
cd /tmp/wiringPi
git clone git://git.drogon.net/wiringPi
cd wiringPi
git pull origin
./build
rm -rf /tmp/wiringPi
