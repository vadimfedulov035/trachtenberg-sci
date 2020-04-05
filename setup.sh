#!/bin/sh

apt install psmisc -y

clean(){
rm -rf get-pip.py*
}

req(){
wget https://bootstrap.pypa.io/get-pip.py
python3.8 get-pip.py
python3.8 -m pip install -r requirements.txt
}

clean

if [ ! `which python3.8 | grep "/usr/bin/python3.8"` ]; then
	echo "\nPython3.8 is not installed, started the process of installation!\n"
	apt install zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libgdbm-dev libssl-dev libnss3-dev libreadline-dev libffi-dev tk-dev libsqlite3-dev -y
	wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
	tar xvf Python-3.8.2.tar.xz
	cd Python-3.8.2
	./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations --with-lto --enable-ipv6 --with-pydebug
	make -j$(nproc)
	make install
	cd ..
	rm -rf Python-3.8.2*
	echo "\nPython installation went successful!\n"
	if [ `which python3.8 | grep "/usr/bin/python3.8"` ]; then
		req
		clean
		echo "\nPython installation with dependencies went successful!\n"
	fi
else
	echo "\nPython3.8 is already installed! Skipping step of installation! Checking dependencies...\n"
	req
	clean
	echo "\nPython installation with dependencies went successful!\n"
	clean
fi
