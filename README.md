# TrachtenbergBot
## Asynchronous telegram bot source code

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

If you have read the original book you will be able to test your knowledge easily by just chatting with bot in Telegram.

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written on its own micro-framework for work with Telegram API and library for working with math operations. Main file is init.sh, this is a shell script which starts start.py which assembles all functionality inside itself. Bot restarts at 21:00 MSK in case some users stopped using the bot and new bot are available for usage.

- [x] Add Arithmetics operations
- [x] Add Linear Algebra operations
- [x] Add asyncio functionality and make code asynchronous
- [x] Optimize code for high effeciency
- [x] Optimize code for PEP-8 standards and improve readability
- [x] Make comments for understandability
- [x] Add ability to hold up to 25 conversations at once (for now)
- [x] Make bot able to have instant messaging with newcomers
- [x] Write server-backend (shell-script for handling restarts of bot)
- [x] Choose CPython realization of Python programming language (for now)
- [x] Translate to Russian (buggy)
- [ ] Wait until release of Cython 3.0.0 for Unicode support and implement it on it
- [ ] Make a real stable version (still implementing new ideas and fixing bugs)
