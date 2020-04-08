# TrachtenbergBot Cython
## Asynchronous telegram chat bot for math 

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

If you have read the original book you will be able to test your knowledge easily by just chatting with TrachtenbergBot in Telegram.

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written in Cython using its own micro-framework for work with Telegram API. It is heavily statically typed for fast work, almost every object is statically defined for speed. 

## Compile bot yourself, if you want to (at least 6GB of RAM is required)

Just run these commands. Shell-script setup.sh installs Python3.8.2 and needed shared libraries and GNU make cythonizes source code and compiles executables from C files following Makefile scenario.

`sudo ./setup.sh` to install all dependencies

`make clean` to remove pre-built executables

`make -j` to compile executables using all cores of CPU

`make clear` to remove all unnecessary .c files

## Start bot on your own computer or VPS/VDS

To start bot you will need pre-compiled or compiled by yourself executables and token written in tok.conf file. You can get token from BotFather in Telegram.

`./init.sh` to enable scheduled work of bot (with restarts at 21:00)

- [x] Add Arithmetics operations
- [x] Add Linear Algebra operations
- [x] Add asyncio functionality and make code asynchronous
- [x] Optimize code for PEP-8 standards and make readable comments
- [x] Make bot able to have instant messaging with newcomers
- [x] Translate to Russian via unicode support
- [x] Port code from Python to Cython and learn how to compile executable using GCC and GNU Make 
- [x] Cythonize code as much as possible for speeding up and decreasing load on CPU
- [x] Make bot more user-friendly and stable
- [x] Write scripts for installing dependencies and scheduled execution of executables handling up to 1000 conversations at once
- [x] Write GNU Makefile scenario
- [x] Release Cython version :tada: :tada: :tada:
