import re
import json
import requests
import time
import sys


import tsmath as tm  # import math library for handling math operations


with open('tok.conf', 'r') as config:  # read Telegram token from file
    token = config.read().split('|')[1]  # for safety, of course


class Bot():


    def __init__(self, tok):
        # setting up timeout between iterations and iteration var
        self.timeout = 3
        self.itera = 1
        # setting up all sets for equations right answers and user supplied
        self.c = set()
        self.c1 = set()
        self.c2 = set()
        self.c3 = set()
        self.uc = set()
        self.uc1 = set()
        self.uc2 = set()
        self.uc3 = set()
        # setting up lists with starting difficulty variables
        self.mnum = [ 2, 1 ]
        self.dnum = [ 4, 2 ]
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


    def sendmsg(self, msg):
        self.cid = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", self.readlm).group(1)
        self.reqms = self.url + f"/sendmessage?text={msg}&chat_id={self.cid}"
        requests.get(self.reqms)  # sending actual request


    def start(self):
        self.readmsg()
        if re.search(r'\/start', self.readlm) or self.restart_choice is True:
            self.sendmsg("Started setting up! Type /restart when set up is done, if you want to change your choice or start again! Don't delete dialog fully!")
            if self.restart_choice is True:  # if we are restarting we
                self.restart_choice = False  # reset special var for restart
            self.count_msg = True
            self.choice()
        
        time.sleep(self.timeout)
        self.start()


    def restart(self):
        self.__init__(token)
        self.restart_choice = True  # set special var for restart
        self.start()


    def choice(self):
        self.readmsg()
        if self.choice_msg is False:  # send message if not yet sent
            self.sendmsg("Do you want a matrix multiplication, simple multiplication or simple division test? (/mmul, /mul or /div):")
            self.choice_msg = True

        if re.search(r"\'text\'\:\s\'\/mul\'", self.readlm):
            self.sendmsg("Multiplication is chosen")
            self.sendmsg("When you want to answer type ([answer])")
            self.chosen = "mul"
            self.numb()
        elif re.search(r"\'text\'\:\s\'\/div\'", self.readlm):
            self.sendmsg("Division is chosen")
            self.sendmsg("When you want to answer type ([answer], [residual])")
            self.chosen = "div"
            self.numb()
        elif re.search(r"\'text'\:\s\'\/mmul\'", self.readlm):
            self.sendmsg("Matrix multiplication is chosen")
            self.sendmsg("When you want to answer type([answer1], [answer2])")
            self.chosen = "mmul"
            self.numb()

        time.sleep(self.timeout)
        self.choice()


    def numb(self):
        self.readmsg()
        self.rpass = re.search(r"\'text\'\:\s\'\/d([0-9]{1,6})\'", self.readlm)

        try:
            self.rpass = int(str(self.rpass.group(1)))
        except:
            pass

        if self.numb_msg is False:  # send message if not yet send
            self.sendmsg('How many iterations do you want before increasing difficulty? (/d[num]):')
            self.numb_msg = True

        if self.rpass:
            self.sendmsg(f"Have chosen {self.rpass} iterations mode")
            if self.chosen == 'mmul':
                self.msized()
            else:
                self.count()

        time.sleep(self.timeout)
        self.numb()


    def msized(self):
        self.readmsg()
        self.smatr = re.search(r"\'text\'\:\s\'\/m([2-4])\'", self.readlm)

        try:
            self.smatr = int(str(self.smatr.group(1)))
        except:
            pass

        if self.msized_msg is False:
            self.sendmsg('How big the matrix should be? 2 or 3 or 2.5 (4)? (/m[num])')
            self.msized_msg = True

        if self.smatr == 2 or self.smatr == 3 or self.smatr == 4:
            if self.smatr == 4:
                self.msize = 2.5
            else:
                self.msize = self.smatr
            self.msized_msg = True
            self.count()
        
        time.sleep(self.timeout)
        self.msized()


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
                tm.ml(self.mnum[0], self.mnum[1], mode='telegram', obj=self)

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
                tm.dl(self.dnum[0], self.dnum[1], mode='telegram', obj=self)

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
                tm.mml(self.mmnum[0], self.mmnum[1], mode='telegram', matrix=self.msize, obj=self)

            self.itera += 1


pbot = Bot(token)  # init bot with token read from file
pbot.start()
