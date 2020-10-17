#!/bin/sh

apt install psmisc -y

clean(){
	rm -rf get-pip.py*
}

req(){
	wget https://bootstrap.pypa.io/get-pip.py
	python3.9 get-pip.py
	python3.9 -m pip install -r requirements.txt
}

clean

if [ ! `which python3.9 | grep "/usr/bin/python3.9"` ]; then
	echo "\nPython3.9.0 is not installed, started the process of installation!\n"
	apt install zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libgdbm-dev libssl-dev libnss3-dev libreadline-dev libffi-dev tk-dev libsqlite3-dev -y  # install prerequisites
	wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz && tar xvf Python-3.9.0.tar.xz && cd Python-3.9.0  # download, untar archive; go to dir
	./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations --with-lto --enable-ipv6 --with-pydebug
	make && make altinstall  # install as independent python3.9
	cd ..
	rm -rf Python*
	echo "\nPython3.9.0 installation went successful!\n"
	if [ `which python3.9 | grep "/usr/bin/python3.9"` ]; then
		req
		clean
		echo "\nPython3.9.0 installation with dependencies went successful!\n"
	fi
else
	echo "\nPython3.9.0 is already installed! Skipping step of installation! Checking dependencies...\n"
	req
	clean
	echo "\nPython3.9.0 installation with dependencies was successful!\n"
	clean
fi
