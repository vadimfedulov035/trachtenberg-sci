# TrachtenbergBot Cython
## Asynchronous telegram chat bot for math 

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

### Python 3.9.0 + Cython 0.29.19 + GCC 10.2.0

If you have read the original book you will be able to test your knowledge easily by just chatting with TrachtenbergBot in Telegram.

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written in Cython using its own micro-framework for work with Telegram API. It is heavily statically typed for fast work, almost every object is statically defined for speed. 

## Compile bot yourself, if you want to

Just run these commands. Shell-script setup.sh installs recent Python 3.9.0 and needed shared libraries and GNU make cythonizes source code and compiles executables from C files following Makefile scenario. (Remember that this shell-script does not install GCC 10.2.0. You can install it by yourself, using ATOIC script at https://github.com/vadimfedulov035/install)

`sudo ./setup.sh` to install all dependencies

`make clean` to remove pre-built executables

`make -j` to compile executables using all cores of CPU

`make clear` to remove all unnecessary .c files

## Start bot on your own computer or VPS/VDS

To start bot you will need pre-compiled with recent GCC or compiled by yourself executables and token written in tok.conf file. You can get token from BotFather in Telegram.

`./init.sh` to enable stable work of bot

- [x] Add Arithmetics operations, Linear Algebra operations
- [x] Add asyncio functionality and make code asynchronous
- [x] Make bot able to have instant messaging with newcomers on Python handling up to 25 conversations at once
- [x] Translate to Russian via unicode support
- [x] Optimize code for PEP-8 standards and make readable comments
- [x] Port code from Python to Cython and learn how to compile executable using GCC and GNU Make 
- [x] Make bot able to have instant messaging with newcomers on Cython handling up to 1000 conversations at once
- [x] Make bot more user-friendly and stable
- [x] Write scripts for installing dependencies and execution of executables 
- [x] Write GNU Makefile scenario and port to GCC 10.2.0
- [x] Optimize by right typization choices and ctuples usage
- [x] Release Cython version 3.2 :tada: :tada: :tada:
