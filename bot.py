#!/usr/bin/python3.7
import itertools
import re
import json
import asyncio
import urllib
import requests
import tmath as tm


if __name__ == "__main__":
    print("This is not a standalone program!")

with open("token.conf", "r") as config:
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
        self.ch_cmod = True
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
            cid = j["message"]["chat"]["id"]
            if cid == self.CID:  # check date only if CID in msg
                date = j["message"]["date"]
                if date >= self.date:
                    self.ldate = date  # update date, if later found
                    self.readlmsg = j["message"]["text"]  # latest msg

    async def sendmsg(self, msg):
        """integrate cid and message into base url"""
        self.s = f"/sendmessage?text={msg}&chat_id={self.CID}"  # prepare link
        self.urls = self.URL + self.s  # add to base url prepared link
        requests.get(self.urls)  # make request

    async def start(self):
        while True:
            await self.readmsg()
            if self.readlmsg == "/start" or self.restart_ch:
                self.pdate = self.ldate  # set date for restart comparison
                self.fmsg = "Started setting up! Type /start when want to restart!"
                await self.sendmsg(self.fmsg)
                if self.restart_ch:
                    self.restart_ch = False  # if restarted - change state
                self.count_msg = True
                break
            await asyncio.sleep(self.TIMEOUT)
        await self.cmode()

    async def restart(self):
        self.__init__(token, self.NUMBER)
        self.restart_ch = True
        await self.start()

    async def cmode(self):
        """Counting Mode: define operation"""
        while True:
            await self.readmsg()  # get latest msg
            """check both last and recorded dates of /start,
            to check if /start command is new; otherwise
            bot will ignore newer command, thinking it is
            the same message, this can happen only during
            restart after not making any choices"""
            if self.readlmsg == "/start" and self.ldate != self.pdate:
                await self.restart()  # check for restart command, date
            if not self.choice_msg:
                ch1 = "Do you want a linear algebra operations: "
                ch2 = "matrix-matrix or vector-matrix multiplication; "
                ch3 = "arithmetics operations: multiplication, "
                ch4 = "division, squaring, taking square root? "
                ch5 = "(/mmul, /vmul, /mul, /div, /sqr, /root):"
                chmsg = ch1 + ch2 + ch3 + ch4 + ch5
                await self.sendmsg(chmsg)
                self.choice_msg = True  # change state; not to resend msg
            """compare latest msg with offered commands"""
            if self.readlmsg == "/mul":
                await self.sendmsg("Multiplication is chosen")
                self.chosen = "mul"  # send state info and update choice var
                break
            elif self.readlmsg == "/div":
                await self.sendmsg("Division is chosen")
                self.chosen = "div"  # send state info and update choice var
                break
            elif self.readlmsg == "/vmul":
                await self.sendmsg("Vector-matrix multiplication is chosen")
                self.chosen = "vmul"  # send state info and update choice var
                break
            elif self.readlmsg == "/mmul":
                await self.sendmsg("Matrix-matrix multiplication is chosen")
                self.chosen = "mmul"  # send state info and update choice var
                break
            elif self.readlmsg == "/sqr":
                await self.sendmsg("Square taking is chosen")
                self.chosen = "sqr"  # send state info and update choice var
                break
            elif self.readlmsg == "/root":
                await self.sendmsg("Square root taking is chosen")
                self.chosen = "root"  # send state info and update choice var
                break
            await asyncio.sleep(self.TIMEOUT)
        """record previous msg and go to the next method"""
        self.prevmsg = self.readlmsg
        await self.diff()

    async def diff(self):
        """Difficulty Speed"""
        while True:
            await self.readmsg()  # read latest msg
            if self.readlmsg == "/start":
                await self.restart()  # check for restart command
            """send method's msg"""
            if not self.numb_msg:
                it1 = "How many iterations do you want before increasing "
                it2 = "difficulty? (/d[num]):"
                self.itmsg = it1 + it2
                await self.sendmsg(self.itmsg)
                self.numb_msg = True  # change state; not to resend msg
            """try to extract diff, restart if got msg and failed"""
            try:
                self.rpass = re.findall(r"^\/d([0-9]{1,6})", self.readlmsg)
                self.rpass = int(self.rpass[0])  # num is extracted here
            except IndexError:
                if self.readlmsg != self.prevmsg:
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue
            """send state info"""
            if self.rpass:  # if num exist we send info about mode
                await self.sendmsg(f"Have chosen {self.rpass} iterations mode")
                break
        """record previous msg and go to the next method"""
        self.prevmsg = self.readlmsg
        await self.chmod()

    async def chmod(self):
        """Diff Init parameters"""
        while True:
            await self.readmsg()  # read latest msg
            if self.readlmsg == "/start":
                await self.restart()  # check for restart command
            elif self.readlmsg == "/0":  # check for continue command
                await self.sendmsg(f"No changes to init mode were made!")
                self.ch_cmod = False
                break
            """send method's msg"""
            if self.chmod_msg is False:
                chm1 = "Do you want to change initial difficulty? If yes type "
                chm2 = "number if only one element is randomised and two "
                chm3 = "numbers if two are. If you don't want to do that "
                chm4 = "type /0!"
                self.chmmsg = chm1 + chm2 + chm3 + chm4
                await self.sendmsg(self.chmmsg)
                self.chmod_msg = True
            """try to extract new parameters, restart if got msg and failed"""
            try:
                if self.readlmsg == self.prevmsg:
                    raise IndexError("Got no new messages!")
                self.chmod = re.findall(r"([0-9]{1,6})", self.readlmsg)
                self.chmod1 = int(self.chmod[0])
                if self.chosen != "sqr" and self.chosen != "root":
                    self.chmod2 = int(self.chmod[1])
            except IndexError:
                if self.readlmsg != self.prevmsg and self.readlmsg != "/0":
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue
            """send state info based on counting mode"""
            if self.chosen != "sqr" and self.chosen != "root":
                chm = f"have chosen [{self.chmod1}, {self.chmod2}] init mode"
                await self.sendmsg(chm)
                break
            else:
                chm = f"Have chosen {self.chmod1} init mode"
                await self.sendmsg(chm)
                break
        """record previous msg and go to the next method
        based on counting mode"""
        self.prevmsg = self.readlmsg
        if self.chosen == "vmul" or self.chosen == "mmul":
            await self.msize()  # for matrix operations we need their size
        else:
            await self.count()  # for basic operation we start counting now

    async def msize(self):
        """Matrix Size"""
        while True:
            await self.readmsg()
            if self.readlmsg == "/start":
                self.restart()  # check for restart command
            """send method's msg"""
            if self.msized_msg is False:
                ms1 = "How big the matrix should be? "
                ms2 = "2 or 3 or 2.5 (4)? "
                ms3 = "(/m2, /m3, /m4):"
                self.msmsg = ms1 + ms2 + ms3
                await self.sendmsg(self.msmsg)
                self.msized_msg = True
            """try to extract msize, restart if got msg and failed"""
            try:  # to extract num from latest msg
                self.smatr = re.findall(r"^\/m([2-4])", self.readlmsg)
                self.smatr = int(self.smatr[0])
            except IndexError:
                if self.readlmsg != self.prevmsg:
                    await self.sendmsg(self.ERROR)
                    await self.restart()
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.smatr == 4:  # 4th option is variation of 2 and 3
                self.msize = 2.5  # so we set float to variable
                break
            else:  # otherwise we set int to variable
                self.msize = self.smatr
                break
        await self.count()  # start counting now

    async def count(self):
        """Counting endless loop"""
        for i in itertools.count(start=1, step=1):  # specially defined loop
            if self.chosen == "mul":  # check for counting mode option
                if self.fmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.mnum[0], self.mnum[1]
                    self.fmul = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % 2 == 0 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % self.rpass == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                await tm.ml(self.n1, self.n2, obj=self)
            elif self.chosen == "div":  # check for counting mode option
                if self.fdiv:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.dnum[0], self.dnum[1]
                    self.fdiv = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.self.n1 += 1  # every 1st pass increase 1st num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                await tm.dl(self.n1, self.n2, obj=self)
            elif self.chosen == "sqr":  # check for counting mode option
                if self.fsqr:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1 = self.chmod1
                    else:
                        self.n1 = self.sqnum
                    self.fsqr = False
                if self.rpass == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every pass increase num
                await tm.sqr(self.n1, obj=self)
            elif self.chosen == "root":  # check for counting mode option
                if self.froot:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1 = self.chmod1
                    else:
                        self.n1 = self.ronum
                    self.froot = False
                if self.rpass == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every pass increase num
                await tm.root(self.n1, obj=self)
            elif self.chosen == "vmul":  # check for counting mode option
                if self.fvmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                    self.fvmul = False  # change state not to reconvert vars
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                else:  # usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                await tm.vml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == "mmul":  # check for counting mode option
                if self.fmmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        self.n1, self.n2 = self.chmod1, self.chmod2
                    else:
                        self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                    self.fmmul = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                else:  # usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                await tm.mml(self.n1, self.n2, matrix=self.msize, obj=self)
