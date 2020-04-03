#!/bin/sh

rm -f *.c *.exe

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
