cd /tmp
rm -rf pyfirmata
mkdir pyfirmata
cd pyfirmata
wget https://bitbucket.org/tino/pyfirmata/get/0.9.4.tar.gz -O pyfirmata.tar.gz
tar -xvf pyfirmata.tar.gz
cd tino*
python setup.py install
