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
        self.sqnum = 2
        self.ronum = 2
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.chmod_msg = False
        self.msized_msg = False
        self.restart_ch = False
        self.ch_chmod = True
        self.fmul = True
        self.fdiv = True
        self.fvmul = True
        self.fmmul = True
        self.fsqr = True
        self.froot = True
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
                ch1 = "Do you want a linear algebra operations: " 
                ch2 = "matrix-matrix or vector-matrix multiplication; "
                ch3 = "arithmetics operations: multiplication, "
                ch4 = "division, squaring, taking square root? "
                ch5 = "(/mmul, /vmul, /mul, /div, /sqr, /root):"
                chmsg = ch1 + ch2 + ch3 + ch4 + ch5  # combine choice msg
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
            elif self.readlmsg == "/sqr":
                await self.sendmsg("Square taking is chosen")
                self.chosen = "sqr"
                break
            elif self.readlmsg == "/root":
                await self.sendmsg("Square root taking is chosen")
                self.chosen = "root"
                break
            await asyncio.sleep(self.TIMEOUT)  # timeout inside loop
        self.prevmsg = self.readlmsg
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
                if self.readlmsg != self.prevmsg:
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue  # go to start of the loop
            if self.rpass:  # if num exist we send info about mode
                await self.sendmsg(f"Have chosen {self.rpass} iterations mode")
                break
        self.prevmsg = self.readlmsg
        await self.chmod()

    async def chmod(self):
        """change of init mode is made here"""
        while True:
            await self.readmsg()
            if self.readlmsg == "/start":
                await self.restart()
            elif self.readlmsg == "/0":
                await self.sendmsg(f"No changes to init mode were made!")
                self.ch_chmod = False
                break
            if self.chmod_msg is False:
                chm1 = "Do you want to change initial difficulty? If yes type "
                chm2 = "number if only one element is randomised and two "
                chm3 = "numbers if two are. If you don't want to do that type /0!"
                self.chmmsg = chm1 + chm2 + chm3
                await self.sendmsg(self.chmmsg)
                self.chmod_msg = True
            try:
                if self.readlmsg == self.prevmsg:
                    raise IndexError("Got no new messages!")
                self.chmod = re.findall(r"([0-9]{1,6})", self.readlmsg)
                if self.chosen != "sqr" and self.chosen != "root":
                    self.chmod1 = int(self.chmod[0])  # num is extracted here
                    self.chmod2 = int(self.chmod[1])
                else:
                    self.chmod1 = int(self.chmod[0])
            except IndexError:  # if not found (no new msgs)
                if self.readlmsg != self.prevmsg and self.readlmsg != "/0":
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue  # go to start of the loop
            if self.chosen != "sqr" and self.chosen != "root":
                if self.chmod1 and self.chmod2:  # if num exist we send info about mode
                    await self.sendmsg(f"Have chosen [{self.chmod1}, {self.chmod2}] init mode")
                    break
            else:
                if self.chmod1:
                    await self.sendmsg(f"Have chosen {self.chmod1} init mode")
                    break
        self.prevmsg = self.readlmsg
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
                if self.readlmsg != self.prevmsg:
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
                if self.fmul:
                    if self.ch_cmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.mnum[0], self.mnum[1]
                    self.fmul = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                    elif i % 2 == 0 and i != 1:
                        self.n2 += 1  # every 1 pass increase second num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                    elif i % self.rpass == 1 and i != 1:
                        self.n2 += 1  # every 1 pass increase second num
                await tm.ml(self.n1, self.n2, obj=self)
            elif self.chosen == "div":
                if self.fdiv:
                    if self.ch_chmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.dnum[0], self.dnum[1]
                    self.fdiv = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.self.n1 += 1  # every 1 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 1 pass increase first num
                await tm.dl(self.n1, self.n2, obj=self)
            elif self.chosen == "vmul":
                if self.fvmul:
                    if self.ch_chmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                    self.fvmul = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 1 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 1 pass increase first num
                await tm.vml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == "mmul":
                if self.fmmul:
                    if self.ch_chmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                    self.fmmul = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 1 pass increase second num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 1 pass increase second num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                await tm.mml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == "sqr":
                if self.fsqr:
                    if self.ch_chmod:
                        self.n1 = self.chmod1
                    else:
                        self.n1 = self.sqnum
                    self.fsqr = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                else:  # for other vars we use usual approach
                    if i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                await tm.sqr(self.n1, obj=self)
            elif self.chosen == "root":
                if self.froot:
                    if self.ch_chmod:
                        self.n1 = self.chmod1
                    else:
                        self.n1 = self.ronum
                    self.froot = False
                if self.rpass == 1:  # for var of 1 we choose special approach
                    if i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                else:  # for other vars we use usual approach
                    if i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 2 pass increase first num
                await tm.root(self.n1, obj=self)
