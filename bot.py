import itertools
import re
import json
import asyncio
import urllib
import requests
import tmath as tm


with open("config.conf", "r") as config:
    token = config.read().split("|")[1]


class Bot():

    def __init__(self, tok, num):
        """static variables are defined here for correct start up"""
        self.NUMBER = num  # num serves as enumerator of cid later
        self.TOKEN = tok  # token for connection to API
        self.TIMEOUT = 0.5  # best timeout for not overloading API
        self.URL = f"https://api.telegram.org/bot{self.TOKEN}"
        self.URLR = self.URL + "/getupdates"
        self.ERROR = "Sorry, I didn't understand you, I will restart dialog!"
        self.MISTYPE = "Sorry, I didn't understand you, type more clearly!"
        """non-static variables are defined here for further work"""
        self.date = 0  # date set to zero will serve in expression as starter
        self.prevmsg = None
        self.c, self.uc = None, None
        self.c1, self.c2, self.c3 = None, None, None
        self.c4, self.c5, self.c6 = None, None, None
        self.c7, self.c8, self.c9 = None, None, None
        self.uc1, self.uc2, self.uc3 = None, None, None
        self.uc4, self.uc5, self.uc6 = None, None, None
        self.uc7, self.uc8, self.uc9 = None, None, None
        self.mnum = [2, 1]
        self.dnum = [4, 2]
        self.vmnum = [1, 2]
        self.mmnum = [1, 2]
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.msized_msg = False
        self.restart_ch = False
        """first request for getting chat ids (cids) is done here"""
        self.msgreq = urllib.request.urlopen(self.URLR)
        self.rj = self.msgreq.read()
        self.j = json.loads(self.rj.decode("utf-8"))
        cids = []
        """parsing loop through all cids"""
        for n in itertools.count():
            try:
                cid = self.j["result"][n]["message"]["chat"]["id"]
                if cid not in cids:
                    cids.append(cid)
            except IndexError:
                break
        self.CID = int(cids[self.NUMBER])  # we pick one cid based on num
        print(f"{self.NUMBER}: {self.CID}")

    async def readmsg(self):
        """new reqest to get fresh json data"""
        self.msgreq = urllib.request.urlopen(self.URLR)
        self.rj = self.msgreq.read()
        self.j = json.loads(self.rj.decode("utf-8"))
        """loop through json to find last message by date"""
        for j in self.j["result"]:
            cid = j["message"]["chat"]["id"]  # check date only if cid is bot"s
            if cid == self.CID:
                date = j["message"]["date"]
                if date >= self.date:  # if date is later then set before
                    self.date = date  # got later date, linked message (msg)
                    self.readlmsg = j["message"]["text"]  # got later msg

    async def sendmsg(self, msg):
        """integrate into static url cid and message"""
        self.s = f"/sendmessage?text={msg}&chat_id={self.CID}"
        self.urls = self.URL + self.s
        requests.get(self.urls)

    async def start(self):
        while True:
            await self.readmsg()
            if self.readlmsg == "/start" or self.restart_ch is True:
                f1 = "Started setting up! Type /start when want to restart, "
                f2 = "if you want to change your choice(s) and start again, "
                f3 = "you can restart after at least one made choice!"
                self.fmsg = f1 + f2 + f3  # combine first msg
                await self.sendmsg(self.fmsg)  # send first msg
                if self.restart_ch is True:
                    self.restart_ch = False
                self.count_msg = True
                break
            await asyncio.sleep(self.TIMEOUT)
        await self.choice()

    async def restart(self):
        self.__init__(token, self.NUMBER)
        self.restart_ch = True
        await self.start()

    async def choice(self):
        """choice of counting mode is done here"""
        while True:
            await self.readmsg()  # read last msg and compare with commands
            if self.choice_msg is False:
                ch1 = "Do you want a matrix-matrix, vector-matrix, "
                ch2 = "simple multiplication or simple division? "
                ch3 = "(/mmul, /vmul, /mul or /div):"
                chmsg = ch1 + ch2 + ch3  # combine choice msg
                await self.sendmsg(chmsg)  # send choice msg
                self.choice_msg = True
            if self.readlmsg == "/mul":
                await self.sendmsg("Multiplication is chosen")
                self.chosen = "mul"
                break
            elif self.readlmsg == "/div":
                await self.sendmsg("Division is chosen")
                self.chosen = "div"
                break
            elif self.readlmsg == "/vmul":
                await self.sendmsg("Vector-matrix multiplication is chosen")
                self.chosen = "vmul"
                break
            elif self.readlmsg == "/mmul":
                await self.sendmsg("Matrix-matrix multiplication is chosen")
                self.chosen = "mmul"
                break
            await asyncio.sleep(self.TIMEOUT)  # timeout inside loop
        await self.numb()  # go further only if we have choice made

    async def numb(self):
        """choice of speed of increasing difficulty is made here"""
        while True:
            await self.readmsg()  # read last msg and extract from command num
            if self.readlmsg == "/start":
                await self.restart()
            if self.numb_msg is False:
                it1 = "How many iterations do you want before increasing "
                it2 = "difficulty? (/d[num]):"
                self.itmsg = it1 + it2
                await self.sendmsg(self.itmsg)
                self.numb_msg = True
            try:
                self.rpass = re.findall(r"^\/d([0-9]{1,6})", self.readlmsg)
                self.rpass = int(self.rpass[0])  # num is extracted here
            except IndexError:  # if not found (no new msgs)
                if self.readlmsg != f"/{self.chosen}":
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue  # go to start of the loop
            if self.rpass:  # if num exist we send info about mode
                await self.sendmsg(f"Have chosen {self.rpass} iterations mode")
                break
        if self.chosen == "vmul" or self.chosen == "mmul":
            await self.msized()  # for matrix operations we need their size
        else:
            await self.count()  # for basic operation we start counting now

    async def msized(self):
        """choice of matrix size is made here"""
        while True:
            await self.readmsg()
            if self.readlmsg == "/start":
                self.restart()
            if self.msized_msg is False:
                ms1 = "How big the matrix should be? "
                ms2 = "2 or 3 or 2.5 (4)? "
                ms3 = "(/m2, /m3, /m4):"
                self.msmsg = ms1 + ms2 + ms3
                await self.sendmsg(self.msmsg)
                self.msized_msg = True
            try:
                self.smatr = re.findall(r"^\/m([2-4])", self.readlmsg)
                self.smatr = int(self.smatr[0])
            except IndexError:  # if not found (no new msgs)
                if self.readlmsg != f"/d{self.rpass}":
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue  # go to start of the loop
            if self.smatr == 4:  # 4th option is variation of 2 and 3
                self.msize = 2.5
                break
            else:  # otherwise we set int to variable
                self.msize = self.smatr
                break
        await self.count()  # start counting now

    async def count(self):
        """counting and functions" calls are done here"""
        for i in itertools.count(start=1, step=1):
            if self.chosen == "mul":
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.mnum[0] += 1  # every 2 pass increase first num
                    elif i % 2 == 0 and i != 1:
                        self.mnum[1] += 1  # every 1 pass increase second num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.mnum[0] += 1  # every 2 pass increase first num
                    elif i % self.rpass == 1 and i != 1:
                        self.mnum[1] += 1  # every 1 pass increase second num
                self.n1, self.n2 = self.mnum[0], self.mnum[1]
                await tm.ml(self.n1, self.n2, obj=self)
            elif self.chosen == "div":
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.dnum[1] += 1  # every 2 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.dnum[0] += 1  # every 1 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.dnum[1] += 1  # every 2 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.dnum[0] += 1  # every 1 pass increase first num
                self.n1, self.n2 = self.dnum[0], self.dnum[1]
                await tm.dl(self.n1, self.n2, obj=self)
            elif self.chosen == "vmul":
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.mmnum[1] += 1  # every 2 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.vmnum[0] += 1  # every 1 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.dnum[1] += 1  # every 2 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.dnum[0] += 1  # every 1 pass increase first num
                self.n1, self.n2 = self.dnum[0], self.dnum[1]
                await tm.vml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == "mmul":
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.mmnum[1] += 1  # every 1 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.mmnum[0] += 1  # every 2 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.mmnum[1] += 1  # every 1 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.mmnum[0] += 1  # every 2 pass increase first num
                self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                await tm.mml(self.n1, self.n2, matrix=self.msize, obj=self)


nbot = 0

while True:
    try:
        pbot1 = Bot(token, 0)
        nbot += 1
    except IndexError:
        print("No users yet")
        continue
    try:
        pbot2 = Bot(token, 1)
        nbot += 1
    except IndexError:
        break
    try:
        pbot3 = Bot(token, 2)
        nbot += 1
    except IndexError:
        break
    try:
        pbot4 = Bot(token, 3)
        nbot += 1
    except IndexError:
        break
    try:
        pbot5 = Bot(token, 4)
        nbot += 1
    except IndexError:
        break
    try:
        pbot6 = Bot(token, 5)
        nbot += 1
    except IndexError:
        break
    try:
        pbot7 = Bot(token, 6)
        nbot += 1
    except IndexError:
        break
    try:
        pbot8 = Bot(token, 7)
        nbot += 1
    except IndexError:
        break
    try:
        pbot9 = Bot(token, 8)
        nbot += 1
    except IndexError:
        break
    try:
        pbot10 = Bot(token, 9)
        nbot += 1
    except IndexError:
        break
    try:
        pbot11 = Bot(token, 10)
        nbot += 1
    except IndexError:
        break
    try:
        pbot12 = Bot(token, 11)
        nbot += 1
    except IndexError:
        break
    try:
        pbot13 = Bot(token, 12)
        nbot += 1
    except IndexError:
        break
    try:
        pbot14 = Bot(token, 13)
        nbot += 1
    except IndexError:
        break
    try:
        pbot15 = Bot(token, 14)
        nbot += 1
    except IndexError:
        break
    try:
        pbot16 = Bot(token, 15)
        nbot += 1
    except IndexError:
        break
    try:
        pbot17 = Bot(token, 16)
        nbot += 1
    except IndexError:
        break
    try:
        pbot18 = Bot(token, 17)
        nbot += 1
    except IndexError:
        break
    try:
        pbot19 = Bot(token, 18)
        nbot += 1
    except IndexError:
        break
    try:
        pbot20 = Bot(token, 19)
        nbot += 1
    except IndexError:
        break
    try:
        pbot21 = Bot(token, 20)
        nbot += 1
    except IndexError:
        break
    try:
        pbot22 = Bot(token, 21)
        nbot += 1
    except IndexError:
        break
    try:
        pbot23 = Bot(token, 22)
        nbot += 1
    except IndexError:
        break
    try:
        pbot24 = Bot(token, 23)
        nbot += 1
    except IndexError:
        break
    try:
        pbot25 = Bot(token, 24)
        nbot += 1
    except IndexError:
        break
    try:
        pbot26 = Bot(token, 25)
        nbot += 1
    except IndexError:
        break
    try:
        pbot27 = Bot(token, 26)
        nbot += 1
    except IndexError:
        break
    try:
        pbot28 = Bot(token, 27)
        nbot += 1
    except IndexError:
        break
    try:
        pbot29 = Bot(token, 28)
        nbot += 1
    except IndexError:
        break
    try:
        pbot30 = Bot(token, 29)
        nbot += 1
    except IndexError:
        break
    else:
        print("Maximum overload")

if nbot == 1:
    async def main():
        await pbot1.start()
elif nbot == 2:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start()
            )
elif nbot == 3:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start()
            )
elif nbot == 4:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start()
            )
elif nbot == 5:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start()
            )
elif nbot == 6:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start()
            )
elif nbot == 7:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start()
            )
elif nbot == 8:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start()
            )
elif nbot == 9:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start()
            )
elif nbot == 10:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start()
            )
elif nbot == 11:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start()
            )
elif nbot == 12:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start()
            )
elif nbot == 13:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start()
            )
elif nbot == 14:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start()
            )
elif nbot == 15:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start()
            )
elif nbot == 16:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start()
            )
elif nbot == 17:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start()
            )
elif nbot == 18:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start()
            )
elif nbot == 19:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start()
            )

elif nbot == 20:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start()
            )
elif nbot == 21:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start()
            )
elif nbot == 22:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start()
            )
elif nbot == 23:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start()
            )
elif nbot == 24:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start()
            )
elif nbot == 25:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start()
            )
elif nbot == 26:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot26.start()
            )
elif nbot == 27:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start()
            )
elif nbot == 28:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start()
            )
elif nbot == 29:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start()
            )
elif nbot == 30:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start()
            )

asyncio.run(main())
