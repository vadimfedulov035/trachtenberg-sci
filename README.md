# TrachtenbergBot
## Asynchronous telegram bot source code

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

If you have read the original book you will be able to test your knowledge easily by just chatting with bot in Telegram.

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written on its own micro-framework for work with Telegram API and library for working with math operations. Main file is init.sh, this is a shell script which starts start.py which assembles all functionality inside itself. Bot restarts at 21:00 MSK in case some users stopped using the bot and new bot are available for usage.

- [x] Add Arithmetics operations
- [x] Add Linear Algebra operations
- [x] Add asyncio functionality and make code asynchronous
- [x] Optimize code for PEP-8 standards and make readable comments
- [x] Make bot able to have instant messaging with newcomers
- [x] Translate to Russian via unicode support
- [x] Port code from CPython to Cython and learn how to compile executable (-02)
- [x] Cythonize code as much as possible for speeding up and decreasing load on CPU
- [ ] Make bot more usable and user-friendly
- [ ] Compile 10 executables for handling up to 100 conversations
- [ ] Write server-backend for handling execution of bot instances
- [ ] Release 2.5 version
