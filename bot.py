import re
import requests
import asyncio
import tmath as tm  # import math library for handling math operations


with open('config.conf', 'r') as config:  # read Telegram token from file
    token = config.read().split('|')[1]  # for safety, of course


class Bot():

    def __init__(self, tok, num):
        # setting initial parameters
        self.number = num
        self.token = tok
        self.ldate = 0
        # setting up timeout between iterations and iteration var
        self.timeout = 0.5
        self.itera = 1
        # setting up all sets for equations right answers and user supplied
        self.c, self.uc = set(), set()
        self.c1, self.c2, self.c3 = set(), set(), set()
        self.c4, self.c5, self.c6 = set(), set(), set()
        self.c7, self.c8, self.c9 = set(), set(), set()
        self.uc1, self.uc2, self.uc3 = set(), set(), set()
        self.uc4, self.uc5, self.uc6 = set(), set(), set()
        self.uc7, self.uc8, self.uc9 = set(), set(), set()
        # setting up lists with starting difficulty variables
        self.mnum = [2, 1]
        self.dnum = [4, 2]
        self.vmnum = [1, 2]
        self.mmnum = [1, 2]
        # setting up check variables for sending messages
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.msized_msg = False
        # set special var for restart
        self.restart_ch = False
        # setting up base url to make operations on it
        self.url = f"https://api.telegram.org/bot{self.token}"
        # send initial request to set cid
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        self.rchid = r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})"
        self.cids = re.findall(self.rchid, str(self.listmsg).lower())
        if self.cids is not None:
            self.fcids = []
            for cid in self.cids:
                if cid not in self.fcids:
                    self.fcids.append(cid)
            self.cid = int(self.fcids[self.number])
            print(f"{self.number}: {self.cid}")

    async def readmsg(self):
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        for msg in self.listmsg:
            msg = str(msg).lower()
            rdate = r"\'date\'\:\s([0-9]{8,12})"
            self.date = int(str(re.search(rdate, msg).group(1)))
            int_id = int(str(re.search(self.rchid, msg).group(1)))
            if self.cid == int_id and self.date >= self.ldate:
                self.ldate = self.date
                self.readlm = msg

    async def sendmsg(self, msg):
        # setting fstring
        self.reqadd = f"/sendmessage?text={msg}&chat_id={self.cid}"
        # setting request
        self.reqms = self.url + self.reqadd
        # sending actual request
        requests.get(self.reqms)

    async def start(self):

        while True:
            await self.readmsg()
            if re.search(r'\/start', self.readlm) or self.restart_ch is True:
                f1 = "Started setting up! Type /restart when set up is done, "
                f2 = "if you want to change your choice or start again! "
                f3 = "Don't delete dialog fully!"
                self.fmsg = f1 + f2 + f3
                await self.sendmsg(self.fmsg)
                if self.restart_ch is True:  # if we are restarting we
                    self.restart_ch = False  # reset special var for restart
                self.count_msg = True
                break
            await asyncio.sleep(self.timeout)
        await self.choice()

    async def restart(self):
        self.__init__(token, self.number)
        self.restart_ch = True  # set special var for restart
        await self.start()

    async def choice(self):
        while True:
            await self.readmsg()
            if self.choice_msg is False:  # send message if not yet sent
                ch1 = "Do you want a matrix-matrix, vector-matrix, "
                ch2 = "simple multiplication or simple division? "
                ch3 = "(/mmul, /vmul, /mul or /div):"
                chmsg = ch1 + ch2 + ch3
                await self.sendmsg(chmsg)
                self.choice_msg = True
            if re.search(r"\'text\'\:\s\'\/mul\'", self.readlm):
                await self.sendmsg("Multiplication is chosen")
                self.chosen = "mul"
                break
            elif re.search(r"\'text\'\:\s\'\/div\'", self.readlm):
                await self.sendmsg("Division is chosen")
                self.chosen = "div"
                break
            elif re.search(r"\'text'\:\s\'\/vmul\'", self.readlm):
                await self.sendmsg("Vector-matrix multiplication is chosen")
                self.chosen = "vmul"
                break
            elif re.search(r"\'text'\:\s\'\/mmul\'", self.readlm):
                await self.sendmsg("Matrix-matrix multiplication is chosen")
                self.chosen = "mmul"
                break
            await asyncio.sleep(self.timeout)
        await self.numb()

    async def numb(self):
        while True:
            await self.readmsg()
            if self.numb_msg is False:  # send message if not yet send
                it1 = "How many iterations do you want before increasing "
                it2 = "difficulty? (/d[num]):"
                self.itmsg = it1 + it2
                await self.sendmsg(self.itmsg)
                self.numb_msg = True
            try:
                self.rit = r"\'text\'\:\s\'\/d([0-9]{1,6})\'"
                self.rpass = re.search(self.rit, self.readlm)
                self.rpass = int(str(self.rpass.group(1)))
            except AttributeError:
                await asyncio.sleep(self.timeout)
                continue
            if self.rpass:
                await self.sendmsg(f"Have chosen {self.rpass} iterations mode")
                break
        if self.chosen == 'vmul' or self.chosen == 'mmul':
            await self.msized()
        else:
            await self.count()

    async def msized(self):
        while True:
            await self.readmsg()
            if self.msized_msg is False:
                ms1 = "How big the matrix should be? "
                ms2 = "2 or 3 or 2.5 (4)? (/m[num]):"
                self.msmsg = ms1 + ms2
                await self.sendmsg(self.msmsg)
                self.msized_msg = True
            try:
                self.rmat = r"\'text\'\:\s\'\/m([2-4])\'"
                self.smatr = re.search(self.rmat, self.readlm)
                self.smatr = int(str(self.smatr.group(1)))
            except AttributeError:
                await asyncio.sleep(self.timeout)
                continue
            if self.smatr == 4:
                self.msize = 2.5
                break
            else:
                self.msize = self.smatr
                break
        await self.count()

    async def count(self):
        while True:
            if self.chosen == 'mul':
                if self.rpass == 1:  # for pass var of 1, use another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mnum[0] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mnum[1] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mnum[0] += 1  # every 2 pass increase diff var
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mnum[1] += 1  # every 1 pass increase diff var
                self.n1, self.n2 = self.mnum[0], self.mnum[1]
                await tm.ml(self.n1, self.n2, obj=self)
            elif self.chosen == 'div':
                if self.rpass == 1:  # for pass var of 1,use another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.dnum[1] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.dnum[0] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.dnum[1] += 1  # every 2 pass increase diff var
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.dnum[0] += 1  # every 1 pass increase diff var
                self.n1, self.n2 = self.dnum[0], self.dnum[1]
                await tm.dl(self.n1, self.n2, obj=self)
            elif self.chosen == 'vmul':
                if self.rpass == 1:  # for pass var of 1, use  another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.vmnum[1] += 1  # every 2 pass increase diff var
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.vmnum[0] += 1  # every 1 pass increase diff var
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase diff var
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.vmnum[0] += 1  # every 1 pass increase diff var
                self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                await tm.vml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == 'mmul':
                if self.rpass == 1:  # for pass var of 1, use another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase diff var
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mmnum[0] += 1  # every 1 pass increase diff var
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase diff var
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mmnum[0] += 1  # every 1 pass increase diff var
                self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                await tm.mml(self.n1, self.n2, matrix=self.msize, obj=self)
            self.itera += 1


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
        print("One user connected")
        break

    try:
        pbot3 = Bot(token, 2)
        nbot += 1
    except IndexError:
        print("Two users connected")
        break

    try:
        pbot4 = Bot(token, 3)
        nbot += 1
    except IndexError:
        print("Three users connected")
        break

    try:
        pbot5 = Bot(token, 4)
        nbot += 1
    except IndexError:
        print("Four users connected")
        break

    try:
        pbot6 = Bot(token, 5)
        nbot += 1
    except IndexError:
        print("Five users connected")
        break

    try:
        pbot7 = Bot(token, 6)
        nbot += 1
    except IndexError:
        print("Six users connected")
        break

    try:
        pbot8 = Bot(token, 7)
        nbot += 1
    except IndexError:
        print("Seven users connected")
        break

    try:
        pbot9 = Bot(token, 8)
        nbot += 1
    except IndexError:
        print("Eight users connected")
        break

    try:
        pbot10 = Bot(token, 9)
        nbot += 1
    except IndexError:
        print("Nine users connected")
        break
    else:
        print("Ten users connected, maximum overload")

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

asyncio.run(main())
