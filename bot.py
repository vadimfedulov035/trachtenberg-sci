import re
import asyncio
import urllib
import requests
import json
import tmath as tm  


with open('config.conf', 'r') as config:  
    token = config.read().split('|')[1]  


class Bot():

    def __init__(self, tok, num):
        self.number = num
        self.token = tok
        self.date = 0
        self.timeout = 0.5
        self.itera = 1
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
        self.url = f"https://api.telegram.org/bot{self.token}"
        self.requp = self.url + "/getupdates"  
        self.msgreq = urllib.request.urlopen(self.requp)  
        self.rj = self.msgreq.read()  
        self.j = json.loads(self.rj.decode('utf-8'))
        n = 0
        cids = []
        while True:
            try:
                cid = self.j['result'][n]['message']['chat']['id']
                if cid not in cids:
                    cids.append(cid)
                n += 1
            except IndexError:
                break
        self.cid = int(cids[self.number])
        print(f"{self.number}: {self.cid}")

    async def readmsg(self):
        self.requp = self.url + "/getupdates"  
        self.msgreq = urllib.request.urlopen(self.requp)  
        self.rj = self.msgreq.read()
        self.j = json.loads(self.rj.decode('utf-8'))
        for j in self.j['result']:
            cid = j['message']['chat']['id']
            if self.cid == cid:
                date = j['message']['date']
                if date >= self.date:
                    self.date = date
                    self.readlm = j['message']['text']

    async def sendmsg(self, msg):
        self.reqadd = f"/sendmessage?text={msg}&chat_id={self.cid}"
        self.reqms = self.url + self.reqadd
        requests.get(self.reqms)

    async def start(self):
        while True:
            await self.readmsg()
            if self.readlm == '/start' or self.restart_ch is True:
                f1 = "Started setting up! Type /restart when set up is done, "
                f2 = "if you want to change your choice or start again!"
                self.fmsg = f1 + f2
                await self.sendmsg(self.fmsg)
                if self.restart_ch is True:  
                    self.restart_ch = False  
                self.count_msg = True
                break
            await asyncio.sleep(self.timeout)
        await self.choice()

    async def restart(self):
        self.__init__(token, self.number)
        self.restart_ch = True  
        await self.start()

    async def choice(self):
        while True:
            await self.readmsg()
            if self.choice_msg is False:  
                ch1 = "Do you want a matrix-matrix, vector-matrix, "
                ch2 = "simple multiplication or simple division? "
                ch3 = "(/mmul, /vmul, /mul or /div):"
                chmsg = ch1 + ch2 + ch3
                await self.sendmsg(chmsg)
                self.choice_msg = True
            if self.readlm == '/mul':
                await self.sendmsg("Multiplication is chosen")
                self.chosen = "mul"
                break
            elif self.readlm == '/div':
                await self.sendmsg("Division is chosen")
                self.chosen = "div"
                break
            elif self.readlm == '/vmul':
                await self.sendmsg("Vector-matrix multiplication is chosen")
                self.chosen = "vmul"
                break
            elif self.readlm == '/mmul':
                await self.sendmsg("Matrix-matrix multiplication is chosen")
                self.chosen = "mmul"
                break
            await asyncio.sleep(self.timeout)
        await self.numb()

    async def numb(self):
        while True:
            await self.readmsg()
            if self.numb_msg is False:  
                it1 = "How many iterations do you want before increasing "
                it2 = "difficulty? (/d[num]):"
                self.itmsg = it1 + it2
                await self.sendmsg(self.itmsg)
                self.numb_msg = True
            try:
                self.rit = r"\/d([0-9]{1,6})"
                self.rpass = re.find(self.rit, self.readlm)
                self.rpass = int(self.rpass[1])
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
                ms2 = "2 or 3 or 2.5 (4)? "
                ms3 = "(/m2, /m3, /m4):"
                self.msmsg = ms1 + ms2 + ms3
                await self.sendmsg(self.msmsg)
                self.msized_msg = True
            try:
                self.smatr = re.find(r"\/m([2-4])", self.readlm)
                self.smatr = int(self.smatr[1])
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
                if self.rpass == 1:  
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mnum[0] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mnum[1] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mnum[0] += 1  
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mnum[1] += 1  
                self.n1, self.n2 = self.mnum[0], self.mnum[1]
                await tm.ml(self.n1, self.n2, obj=self)
            elif self.chosen == 'div':
                if self.rpass == 1:  
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.dnum[1] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.dnum[0] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.dnum[1] += 1  
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.dnum[0] += 1  
                self.n1, self.n2 = self.dnum[0], self.dnum[1]
                await tm.dl(self.n1, self.n2, obj=self)
            elif self.chosen == 'vmul':
                if self.rpass == 1:  
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.vmnum[1] += 1  
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.vmnum[0] += 1  
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.vmnum[0] += 1  
                self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                await tm.vml(self.n1, self.n2, matrix=self.msize, obj=self)
            elif self.chosen == 'mmul':
                if self.rpass == 1:  
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mmnum[1] += 1  
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mmnum[0] += 1  
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mmnum[0] += 1  
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

