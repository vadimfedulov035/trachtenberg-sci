import re
import json
import requests
import time
import sys
import asyncio


import tmath as tm  # import math library for handling math operations



with open('tok.conf', 'r') as config:  # read Telegram token from file
    token = config.read().split('|')[1]  # for safety, of course


class Bot():


    def __init__(self, tok, num):
        # setting up timeout between iterations and iteration var
        self.num = num
        self.timeout = 1
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
        self.mnum = [ 2, 1 ]
        self.dnum = [ 4, 2 ]
        self.vmnum = [ 1, 2 ]
        self.mmnum = [ 1, 2 ]
        # setting up check variables for sending messages
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.msized_msg = False
        # set special var for restart
        self.restart_choice = False
        # setting up base url to make operations on it
        self.url = f"https://api.telegram.org/bot{tok}"
        # send initial request to set cid
        self.readlm = 'placeholder'
        self.date = 1
        self.ldate = 0
        self.fcids = [  ]
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        self.cids = re.findall(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", str(self.listmsg).lower())
        for cid in self.cids:
            if cid not in self.fcids:
                self.fcids.append(cid)
        self.cid = int(self.fcids[self.num])
        print(f"{self.num} : {self.cid}")


    async def readmsg(self):
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        for msg in self.listmsg:
            msg = str(msg).lower()
            self.date = int(str(re.search(r"\'date\'\:\s([0-9]{8,12})", msg).group(1)))
            if self.cid == int(str(re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", msg).group(1))) and self.date >= self.ldate:
                self.ldate = self.date
                self.readlm = msg


    async def sendmsg(self, msg):
        self.reqms = self.url + f"/sendmessage?text={msg}&chat_id={self.cid}"
        requests.get(self.reqms)  # sending actual request


    async def start(self):

        while True:

            await self.readmsg()

            if re.search(r'\/start', self.readlm) or self.restart_choice is True:
                await self.sendmsg("Started setting up! Type /restart when set up is done, if you want to change your choice or start again! Don't delete dialog fully!")

                if self.restart_choice is True:  # if we are restarting we
                    self.restart_choice = False  # reset special var for restart
                self.count_msg = True
                break

            await asyncio.sleep(self.timeout)
        await self.choice()


    async def restart(self):
        self.__init__(token)
        self.restart_choice = True  # set special var for restart
        await self.start()


    async def choice(self):

        while True:

            await self.readmsg()

            if self.choice_msg is False:  # send message if not yet sent
                await self.sendmsg("Do you want a matrix-matrix, vector-matrix, simple multiplication or simple division? (/mmul, /vmul, /mul or /div):")
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
                await self.sendmsg('How many iterations do you want before increasing difficulty? (/d[num]):')
                self.numb_msg = True

            try:
                self.rpass = re.search(r"\'text\'\:\s\'\/d([0-9]{1,6})\'", self.readlm)
                self.rpass = int(str(self.rpass.group(1)))
            except:
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
                await self.sendmsg('How big the matrix should be? 2 or 3 or 2.5 (4)? (/m[num])')
                self.msized_msg = True

            try:
                self.smatr = re.search(r"\'text\'\:\s\'\/m([2-4])\'", self.readlm)
                self.smatr = int(str(self.smatr.group(1)))
            except:
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
                if self.rpass == 1:  # for pass var of 1 we choose another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mnum[0] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mnum[1] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mnum[0] += 1  # every 2 pass increase difficulty value
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mnum[1] += 1  # every 1 pass increase difficulty value
                await tm.ml(self.mnum[0], self.mnum[1], obj=self)

            elif self.chosen == 'div':
                if self.rpass == 1:  # for pass var of 1 we choose another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.dnum[1] += 1
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.dnum[0] += 1
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.dnum[1] += 1  # every 2 pass increase difficulty value
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.dnum[0] += 1  # every 1 pass increase difficulty value
                await tm.dl(self.dnum[0], self.dnum[1], obj=self)

            elif self.chosen == 'vmul':
                if self.rpass == 1:  # for pass var of 1 we choose another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.vmnum[1] += 1  # every 2 pass increase difficulty value
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.vmnum[0] += 1  # every 1 pass increase difficulty value
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase difficulty value
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.vmnum[0] += 1  # every 1 pass increase difficulty value
                await tm.vml(self.vmnum[0], self.vmnum[1], matrix=self.msize, obj=self)

            
            elif self.chosen == 'mmul':
                if self.rpass == 1:  # for pass var of 1 we choose another approach
                    if self.itera % 2 == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase difficulty value
                    elif self.itera % 2 == 0 and self.itera != 1:
                        self.mmnum[0] += 1  # every 1 pass increase difficulty value
                else:
                    if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                        self.mmnum[1] += 1  # every 2 pass increase difficulty value
                    elif self.itera % self.rpass == 1 and self.itera != 1:
                        self.mmnum[0] += 1  # every 1 pass increase difficulty value
                tm.mml(self.mmnum[0], self.mmnum[1], matrix=self.msize, obj=self)

            self.itera += 1


pbot1 = Bot(token, 0)
pbot2 = Bot(token, 1)
async def main():
    await asyncio.gather(pbot1.start(),pbot2.start())

asyncio.run(main())
