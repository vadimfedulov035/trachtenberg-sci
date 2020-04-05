# TrachtenbergBot
## Asynchronous telegram chat bot for math 

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

If you have read the original book you will be able to test your knowledge easily by just chatting with bot in Telegram.

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written on Cython using its own micro-framework for work with Telegram API. It is heavily statically typed for fast work, almost every object statically defined for speed. Main file is init.sh, this is a shell script which starts Cython + GCC compiled executable. To compile the same executable yourself you will need at least 4GB of RAM. If you want to repeat all my steps you just need to start script setup.sh and choose no to use pre-build executable.

- [x] Add Arithmetics operations
- [x] Add Linear Algebra operations
- [x] Add asyncio functionality and make code asynchronous
- [x] Optimize code for PEP-8 standards and make readable comments
- [x] Make bot able to have instant messaging with newcomers
- [x] Translate to Russian via unicode support
- [x] Port code from CPython to Cython and learn how to compile executable (-02)
- [x] Cythonize code as much as possible for speeding up and decreasing load on CPU
- [x] Make bot more user-friendly and stable
- [x] Write script for compilation of executable for handling up to 1000 conversations
- [ ] Release 3.0 version :tada: :tada: :tada:
