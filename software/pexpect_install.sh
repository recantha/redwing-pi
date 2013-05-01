PWD=`pwd`
mkdir /tmp/pexpect
cd /tmp/pexpect
rm -rf pexpect*
wget http://pexpect.sourceforge.net/pexpect-2.3.tar.gz
tar -xvf pexpect*gz
cd pexpect-2.3
python ./setup.py install
cd $PWD
rm -rf /tmp/pexpect
