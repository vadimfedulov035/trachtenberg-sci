#!/bin/sh
# apt install nano vim tmux git gcc psmisc locales-all -y
trap 'exfunc' 2

exfunc(){
rm -rf *.py *.c *.exe
exit 0
}

req(){
wget https://bootstrap.pypa.io/get-pip.py
python3.8 get-pip.py
python3.8 -m pip install -r requirements.txt
}


clean(){
rm -rf *.c *.py
}

echo "\nCleaning everything up..."
clean
rm -rf *.exe
echo "Cleaning process is done!\n"

read -p "Do you want to use pre-built cbot? (choose this if don't have enough power only) (yes/no): " build

if [ ! `which python3.8 | grep "/usr/bin/python3.8"` ]; then
	echo "Python3.8 is not installed, started the process of installation!\n"
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
		echo "\nPython installation with dependencies went successful!\n"
	fi
else
	echo "Python3.8 is already installed! Skipping step of installation! Checking dependencies...\n"
	req
	echo "\nPython installation with dependencies went successful!\n"
fi

if [ "$build" = "no" ]; then
	echo "Started cythonization of code..."
	python3.8 -m cython -3 --embed cbot.pyx
	echo "Cythonization is over, C files are ready for compilation!\n"

	echo "Compiling cbot..."
	gcc -static-libgcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot.c -o cbot.exe
	echo "Compilation of cbot is done!\n"

	echo "Cleaning everything up..."
	clean
	echo "Cleaning process is done!\n"
fi
