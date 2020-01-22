# Trachtenberg speed system of basic mathematics
## Telegram bot source code and book itself

![cover](https://github.com/vadimfedulov395/trachtenberg-sci/raw/master/cover.jpg)

If you have read the original book you will be able to test your knowledge easily by just chatting with bot in Telegram.
In future releases the bot will be able to hold more than only one dialog with the help of async.

To test on your computer:

'python3 berg.py' for test in any OS where Python is installed

'./berg.exe' for test in any distribution excluding Windows

'./berg.sh' for test in any GNU/Linux distribution where /usr/bin/sh is linked to Dash

If you want to, you can explore the source code of TrachtenbergBot in Telegram, it is written on its own micro-framework from
scratch. It accesses Telegram API without any intermediate libraries, except native Python and NumPy. Because of complex function
and operations it is able to continue only one conversation. If you want to test bot now, just put token into tok.conf and then start it by:

'python3 bot.py' to start bot with Python

'./bot.exe' to start bot with power of cows and Cython + GCC compiled binary
