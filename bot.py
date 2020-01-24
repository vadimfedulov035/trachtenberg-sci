import re
import json
import requests
import time
import sys


import tmath as tm  # import math library for handling math operations



with open('tok.conf', 'r') as config:  # read Telegram token from file
    token = config.read().split('|')[1]  # for safety, of course


class Bot():


    def __init__(self, tok):
        # setting up timeout between iterations and iteration var
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


    def readmsg(self):
        self.requp = self.url + "/getupdates"  # set var for request
        self.msgreq = requests.get(self.requp)  # send actual request
        self.listmsg = self.msgreq.json().get('result')  # get all messages
        self.readlm = str(self.listmsg[-1]).lower()  # pick the last one
        self.cid = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", self.readlm).group(1)

    def sendmsg(self, msg):
        self.reqms = self.url + f"/sendmessage?text={msg}&chat_id={self.cid}"
        requests.get(self.reqms)  # sending actual request


    def start(self):

        while True:

            self.readmsg()

            if re.search(r'\/start', self.readlm) or self.restart_choice is True:
                self.sendmsg("Started setting up! Type /restart when set up is done, if you want to change your choice or start again! Don't delete dialog fully!")

                if self.restart_choice is True:  # if we are restarting we
                    self.restart_choice = False  # reset special var for restart
                self.count_msg = True
                break

            time.sleep(self.timeout)
        self.choice()


    def restart(self):
        self.__init__(token)
        self.restart_choice = True  # set special var for restart
        self.start()


    def choice(self):

        while True:

            self.readmsg()

            if self.choice_msg is False:  # send message if not yet sent
                self.sendmsg("Do you want a matrix-matrix, vector-matrix, simple multiplication or simple division? (/mmul, /vmul, /mul or /div):")
                self.choice_msg = True

            if re.search(r"\'text\'\:\s\'\/mul\'", self.readlm):
                self.sendmsg("Multiplication is chosen")
                self.sendmsg("When you want to answer type ([answer])")
                self.chosen = "mul"
                break
            elif re.search(r"\'text\'\:\s\'\/div\'", self.readlm):
                self.sendmsg("Division is chosen")
                self.sendmsg("When you want to answer type ([answer], [residual])")
                self.chosen = "div"
                break
            elif re.search(r"\'text'\:\s\'\/vmul\'", self.readlm):
                self.sendmsg("Vector-matrix multiplication is chosen")
                self.sendmsg("When you want to answer type([answer1], [answer2])")
                self.chosen = "vmul"
                break
            elif re.search(r"\'text'\:\s\'\/mmul\'", self.readlm):
                self.sendmsg("Matrix-matrix multiplication is chosen")
                self.chosen = "mmul"
                break

            time.sleep(self.timeout)

        self.numb()


    def numb(self):

        while True:

            self.readmsg()

            if self.numb_msg is False:  # send message if not yet send
                self.sendmsg('How many iterations do you want before increasing difficulty? (/d[num]):')
                self.numb_msg = True

            try:
                self.rpass = re.search(r"\'text\'\:\s\'\/d([0-9]{1,6})\'", self.readlm)
                self.rpass = int(str(self.rpass.group(1)))
            except:
                time.sleep(self.timeout)
                continue

            if self.rpass:
                self.sendmsg(f"Have chosen {self.rpass} iterations mode")
                break


        if self.chosen == 'vmul' or self.chosen == 'mmul':
            self.msized()
        else:
            self.count()


    def msized(self):

        while True:

            self.readmsg()

            if self.msized_msg is False:
                self.sendmsg('How big the matrix should be? 2 or 3 or 2.5 (4)? (/m[num])')
                self.msized_msg = True

            try:
                self.smatr = re.search(r"\'text\'\:\s\'\/m([2-4])\'", self.readlm)
                self.smatr = int(str(self.smatr.group(1)))
            except:
                time.sleep(self.timeout)
                continue

            if self.smatr == 4:
                self.msize = 2.5
                break
            else:
                self.msize = self.smatr
                break

        self.count()


    def count(self):

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
                tm.ml(self.mnum[0], self.mnum[1], obj=self)

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
                tm.dl(self.dnum[0], self.dnum[1], obj=self)

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
                tm.vml(self.vmnum[0], self.vmnum[1], matrix=self.msize, obj=self)

            
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


pbot = Bot(token)
pbot.start()
