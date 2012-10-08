clear
echo "TBO Player install"
echo "Have you installed pexpect? If not, please do CTRL-C and then install that first."
echo "Press any key to continue if you have installed pexpect already"
read -n1 -s

PWD=`pwd`
mkdir /tmp/tboplayer 2>/dev/null
cd /tmp/tboplayer
wget https://raw.github.com/KenT2/tboplayer/c833a0df2cf6b509d757984fd1c3554baa77b6b3/tboplayer.py
chmod +x tboplayer.py
mv tboplayer.py /usr/bin/
cd $PWD
rm -rf /tmp/tboplayer
