import time
import re
import random
import json
import requests
import asyncio


import numpy as np



async def ml(multiplicand, multiplier, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1

    a = random.randint(x1, y1)
    b = random.randint(x2, y2)
    c = a * b

    # bot won't ask equation with the same answer, for novelty check
    if c in obj.c:
        await ml(multiplicand, multiplier, obj=obj)
    else:
        obj.c.add(c)  # add answer if unique

    await obj.sendmsg(f"{a} * {b} = ?")

    while True:

        await asyncio.sleep(obj.timeout)
        await obj.readmsg()
        
        if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
            await obj.restart()

        try:
            uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\'", obj.readlm)
            uc = int(str(uc.group(1)))
        except:
            continue

        if uc in obj.uc:  # if user answer is in list then it's old
            continue  # wait for new message
        else:
            obj.uc.add(uc)  # add user answer if unique
            if uc == c:
                await obj.sendmsg("You're God Damn right!")
                break
            elif uc != c:
                await obj.sendmsg(f"No, right answer is {c}!")
                break


async def dl(dividend, divider, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
    for i in range(dividend - 1):
        x1 *= 10
    for i in range(dividend):
        y1 *= 10
    for i in range(divider - 1):
        x2 *= 10
    for i in range(divider):
        y2 *= 10
    y1 -= 1
    y2 -= 1

    a = random.randint(x1, y1)
    b = random.randint(x2, y2)
    c1 = a // b
    c2 = a % b

    # bot won't ask equation with the same answer, for novelty check
    if c1 in obj.c1 or c2 in obj.c2:
        await dl(dividend, divider, obj=obj)
    else:
        obj.c1.add(c1)  # add answer if unique
        obj.c2.add(c2)  # add residual if unique
    
    await obj.sendmsg(f"{a} // | % {b} = ?")
    
    while True:

        await asyncio.sleep(obj.timeout)
        await obj.readmsg()

        if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
            await obj.restart()

        try:
            uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
            uc1, uc2 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2)])
        except:
            continue

        if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
            continue  # wait for new message
        else:
            obj.uc1.add(uc1)  # add user answer if unique
            obj.uc2.add(uc2)  # add user residual if unique
            if uc1 == c1 and uc2 == c2:
                await obj.sendmsg("You're God Damn right!")
                break
            else:
                await obj.sendmsg(f"No, right answer is {c1} with residual of {c2}!")
                break


async def vml(multiplicand, multiplier, matrix=2, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1

    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    
    if matrix == 2:
        
        a = np.matrix([[a1, b1],
                       [a2, b2]])
        
        b = np.matrix([[l1],
                       [l2]])
    
    elif matrix == 3:
        
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        
        a3 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        l3 = random.randint(x2, y2)
        
        a = np.matrix([[a1, b1, c1],
                       [a2, b2, c2],
                       [a3, b3, c3]])

        b = np.matrix([[l1],
                       [l2],
                       [l3]])

    elif matrix == 2.5:
        choices = [ "2x3", "3x2" ]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])

        if matrix == 2.5 and fch == "2x3":
            c1 = random.randint(x1, y1)
            c2 = random.randint(x1, y1)

            l3 = random.randint(x2, y2)

            a = np.matrix([[a1, b1, c1],
                           [a2, b2, c2]])

            b = np.matrix([[l1],
                           [l2],
                           [l3]])

        elif matrix == 2.5 and fch == "3x2":
            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)
            
            a = np.matrix([[a1, b1],
                           [a2, b2],
                           [a3, b3]])

            b = np.matrix([[l1],
                           [l2]])

    c = np.matmul(a, b)

    if matrix == 2 or matrix == 2.5 and fch == "2x3":
        
        c1, c2 = map(lambda x: int(x), [c[0], c[1]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2:
            await vml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c2)  # add answer if unique
            obj.c2.add(c2)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                continue  # wait for new message
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                if uc1 == c1 and uc2 == c2:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}!")
                    break

    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
        
        c1, c2, c3 = map(lambda x: int(x), [c[0], c[1], c[2]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2 or c3 in obj.c3:
            await mml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answer if unique
            obj.c2.add(c2)
            obj.c3.add(c3)


        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()

            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2 or uc3 in obj.uc3:  # if user answers are in lists, then they're old
                continue  # wait for new message
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                if uc1 == c1 and uc2 == c2 and uc3 == c3:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}!")
                    break


async def mml(multiplicand, multiplier, matrix=2, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1

    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    q1 = random.randint(x2, y2)
    q2 = random.randint(x2, y2)
    
    if matrix == 2:
        
        a = np.matrix([[a1, b1],
                       [a2, b2]])

        b = np.matrix([[l1, q1],
                       [l2, q2]])

    elif matrix == 3:
        
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        s1 = random.randint(x2, y2)
        s2 = random.randint(x2, y2)
        a3 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        l3 = random.randint(x2, y2)
        q3 = random.randint(x2, y2)
        s3 = random.randint(x2, y2)

        a = np.matrix([[a1, b1, c1],
                       [a2, b2, c2],
                       [a3, b3, c3]])

        b = np.matrix([[l1, q1, s1],
                       [l2, q2, s2],
                       [l3, q3, s3]])

    elif matrix == 2.5:

        choices = [ "2x3", "3x2" ]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])

        if matrix == 2.5 and fch == "2x3":
            
            c1 = random.randint(x2, y2)
            c2 = random.randint(x2, y2)
            l3 = random.randint(x2, y2)
            q3 = random.randint(x2, y2)

            a = np.matrix([[a1, b1, c1],
                           [a2, b2, c2]])

            b = np.matrix([[l1, q1],
                           [l2, q2],
                           [l3, q3]])

        elif matrix == 2.5 and fch == "3x2":

            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)

            s1 = random.randint(x2, y2)
            s2 = random.randint(x2, y2)

            a = np.matrix([[a1, b1],
                           [a2, b2],
                           [a3, b3]])

            b = np.matrix([[l1, q1, s1],
                           [l2, q2, s2]])

    c = np.matmul(a, b)

    if matrix == 2 or matrix == 2.5 and fch == "2x3":
        
        c1, c2, c3, c4 = map(lambda x: int(x), [c[0, 0], c[0, 1], c[1, 0], c[1, 1]])

        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2:
            await mml(multiplicand, multiplier, obj=obj)
        elif c3 in obj.c3 or c4 in obj.c4:
            await mml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answer if unique
            obj.c2.add(c2)
            obj.c3.add(c3)
            obj.c4.add(c4)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()
            
            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3, uc4 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3), uc.group(4)])
            except:
                continue
            
            if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                continue  # wait for new message 
            elif uc3 in obj.uc3 or uc4 in obj.uc4:
                continue
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                obj.uc4.add(uc4)

                if uc1 == c1 and uc2 == c2 and uc3 == c3 and uc4 == c4:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}, {c4}")
                    break

    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
        
        c1, c2, c3 = map(lambda x: int(x), [c[0, 0], c[0, 1], c[0, 2]])
        c4, c5, c6 = map(lambda x: int(x), [c[1, 0], c[1, 1], c[1, 2]])
        c7, c8, c9 = map(lambda x: int(x), [c[2, 1], c[2, 1], c[2, 2]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2 or c3 in obj.c3:
            await mml(multiplicand, multiplier, obj=obj)
        elif c4 in obj.c4 or c5 in obj.c5 or c6 in obj.c6:
            await mml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answers if unique
            obj.c2.add(c2)
            obj.c3.add(c3)
            obj.c4.add(c4)
            obj.c5.add(c5)
            obj.c6.add(c6)
            obj.c7.add(c7)
            obj.c8.add(c8)
            obj.c9.add(c9)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()

            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10}),\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3)])
                uc4, uc5, uc6 = map(lambda x: int(str(x)), [uc.group(4), uc.group(5), uc.group(6)])
                uc7, uc8, uc9 = map(lambda x: int(str(x)), [uc.group(7), uc.group(8), uc.group(9)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2 or uc3 in obj.uc3:  # if user answers are in lists, then they're old
                continue  # wait for new message
            elif uc4 in obj.uc4 or uc5 in obj.uc5 or uc6 in obj.uc6: 
                continue
            elif uc7 in obj.uc7 or uc8 in obj.uc8 or uc9 in obj.uc9: 
                continue
            else:
                obj.uc1.add(uc1)
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                obj.uc4.add(uc4)
                obj.uc5.add(uc5)
                obj.uc6.add(uc6)
                obj.uc7.add(uc7)
                obj.uc8.add(uc8)
                obj.uc9.add(uc9)
                if uc1 == c1 and uc2 == c2 and uc3 == c3:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}, {c4}, {c5}, {c6}, {c7}, {c8}, {c9}!")
                    break


token = '1000079888:AAFPbORrngm71pZFDgmrLdiCXHWcwGxY70U'


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
        self.url = f"https://api.telegram.org/bot{self.token}"
        # send initial request to set cid
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        self.cids = re.findall(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", str(self.listmsg).lower())
        if self.cids is not None:
            self.fcids = [  ]
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
            self.date = int(str(re.search(r"\'date\'\:\s([0-9]{8,12})", msg).group(1)))
            if self.cid == int(str(re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", msg).group(1))) and self.date >= self.ldate:
                self.ldate = self.date
                self.readlm = msg


    async def sendmsg(self, msg):
        self.reqms = self.url + f"/sendmessage?text={msg}&chat_id={self.cid}" # setting request
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
        self.__init__(token, self.number)
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
                await ml(self.mnum[0], self.mnum[1], obj=self)

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
                await dl(self.dnum[0], self.dnum[1], obj=self)

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
                await vml(self.vmnum[0], self.vmnum[1], matrix=self.msize, obj=self)

            
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
                await mml(self.mmnum[0], self.mmnum[1], matrix=self.msize, obj=self)

            self.itera += 1


nbot = 0

while True:

    try:
        pbot1 = Bot(token, 0)
        nbot += 1
    except:
        print("No users yet")
        continue

    try:
        pbot2 = Bot(token, 1)
        nbot += 1
    except:
        print("One user connected")
        break

    try:
        pbot3 = Bot(token, 2)
        nbot += 1
    except:
        print("Two users connected")
        break

    try:
        pbot4 = Bot(token, 3)
        nbot += 1
    except:
        print("Three users connected")
        break

    try:
        pbot5 = Bot(token, 4)
        nbot += 1
    except:
        print("Four users connected")
        break

    try:
        pbot6 = Bot(token, 5)
        nbot += 1
    except:
        print("Five users connected")
        break

    try:
        pbot7 = Bot(token, 6)
        nbot += 1
    except:
        print("Six users connected")
        break

    try:
        pbot8 = Bot(token, 7)
        nbot += 1
    except:
        print("Seven users connected")
        break

    try:
        pbot9 = Bot(token, 8)
        nbot += 1
    except:
        print("Eight users connected")
        break

    try:
        pbot10 = Bot(token, 9)
        nbot += 1
    except:
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
        await asyncio.gather( [
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
            ] )

asyncio.run(main())
