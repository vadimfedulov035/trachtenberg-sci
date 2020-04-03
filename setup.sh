#!/bin/sh

apt install nano vim tmux git gcc psmisc locales-all-y

echo "Cleaning everything up..."
rm -f *.c *.exe
echo "Cleaning process is done!\n"

if [ ! `which python3.8 | grep "/usr/bin/python3.8"` ]; then
	echo "Python3.8 is not installed, started the process of installation!\n"
	apt install zlib1g-dev libbz2-dev liblz-dev libncurses5-dev libgdbm-dev libssl-dev libnss3-dev libreadline-dev libffi-dev tk-dev libsqlite3-dev -y
	wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
	tar xvf Python-3.8.2.tar.xz
	cd Python-3.8.2
	./configure --prefix=/usr --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations --with-lto --enable-ipv6 --with-pydebug
	make -j$(nproc)
	make install
	cd ..
	rm -rf Python-3.8.2*
	if [ `which python3.8 | grep "/usr/bin/python3.8"` ]; then
		echo "\nPython installation went successful\n"
		wget https://bootstrap.pypa.io/get-pip.py
		python3.8 get-pip.py
		python3.8 -m pip install -r requirements.txt
		echo "\nPython installation with requirements went successful!\n"
	else
		echo "\nPython installation went wrong...\n"
		exit
	fi
else
	echo "Python3.8 is already installed! Skipping step of installation!\n"
fi


echo "Started Cythonization of code..."
python3.8 -m cython -3 --embed cidc.pyx
python3.8 -m cython -3 --embed cbot0.pyx
python3.8 -m cython -3 --embed cbot1.pyx
python3.8 -m cython -3 --embed cbot2.pyx
python3.8 -m cython -3 --embed cbot3.pyx
python3.8 -m cython -3 --embed cbot4.pyx
python3.8 -m cython -3 --embed cbot5.pyx
python3.8 -m cython -3 --embed cbot6.pyx
python3.8 -m cython -3 --embed cbot7.pyx
python3.8 -m cython -3 --embed cbot8.pyx
python3.8 -m cython -3 --embed cbot9.pyx
echo "Cythonization is over, C files are ready for compilation!\n"

echo "Compiling CID collector..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cidc.c -o cidc.exe
echo "Compiling CID collector is done!\n"

echo "Compiling 1st instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot0.c -o cbot0.exe
echo "Compiling 1st instanse of bot is done!\n"

echo "Compiling 2nd instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot1.c -o cbot1.exe
echo "Compiling 2nd instanse of bot is done!\n"

echo "Compiling 3rd instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot2.c -o cbot2.exe
echo "Compiling 3rd instanse of bot is done!\n"

echo "Compiling 4th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot3.c -o cbot3.exe
echo "Compiling 4th instanse of bot is done!\n"

echo "Compiling 5th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot4.c -o cbot4.exe
echo "Compiling 5th instanse of bot is done!\n"

echo "Compiling 6th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot5.c -o cbot5.exe
echo "Compiling 6th instanse of bot is done!\n"

echo "Compiling 7th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot6.c -o cbot6.exe
echo "Compiling 7th instanse of bot is done!\n"

echo "Compiling 8th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot7.c -o cbot7.exe
echo "Compiling 8th instanse of bot is done!\n"

echo "Compiling 9th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot8.c -o cbot8.exe
echo "Compiling 9th instanse of bot is done!\n"

echo "Compiling 10th instance of bot..."
gcc -fPIC -pthread -O2 -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include -L/usr/lib/x86_64-linux-gnu -lpython3.8d cbot9.c -o cbot9.exe
echo "Compiling 10th instanse of bot is done!\n"

echo "Cleaning up all C files..."
rm *.c
echo "Cleaned up all C files!"
