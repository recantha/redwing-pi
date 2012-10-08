clear
echo "Installing bluetooth, bluez-utils and bluez-compat"

apt-get update
apt-get install bluetooth
apt-get install bluez-utils
# need the next one for 'hidd'
apt-get install bluez-compat
service bluetooth restart

echo "All done"
