import re
import json
import requests
import time
import sys


import tsmath as tm  # import math module for handling math operations



sys.setrecursionlimit(2000000000)  # set high limit of recursion for later use


with open('tok.conf', 'r') as config:  # read Telegram token from file
    token = config.read().split('|')[1]  # for safety, of course


class Bot():


    def __init__(self, tok):
        # setting up timeout between iterations and iteration var
        self.timeout = 1
        self.itera = 1
        # setting up all lists for equations right answers and user supplied
        self.c = [ ]
        self.c1 = [ ]
        self.c2 = [ ]
        self.uc = [ ]
        self.uc1 = [ ]
        self.uc2 = [ ]
        # setting up starting difficulty variables
        self.mnum = [ 2, 1 ]
        self.dnum = [ 4, 2 ]
        # setting up check variables for sending messages
        self.convert_rpass = False
        self.convert_nitera = False
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.repeat_choice_msg = False
        self.repeat_count_msg = False
        self.repeat_numb_msg = False
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
        if self.start_msg is False:  # if no new messages repeat
            time.sleep(self.timeout)
            self.start()


    def restart(self):
        self.__init__(token)
        self.restart_choice = True  # set special var for restart
        self.start()


    def choice(self):
        self.readmsg()
        if self.repeat_choice_msg is False:  # send message if not yet sent
            self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
            self.repeat_choice_msg = True
        if re.search(r"\'text\'\:\s\'\/mul\'", self.readlm):
            self.sendmsg("Multiplication is chosen")
            self.sendmsg("When you want to answer type ([answer])")
            self.choice_msg = True
            self.chosen = "mul"
            self.numb()
        elif re.search(r"\'text\'\:\s\'\/div\'", self.readlm):
            self.sendmsg("Division is chosen")
            self.sendmsg("When you want to answer type ([answer], [residual])")
            self.choice_msg = True
            self.chosen = "div"
            self.numb()
        if self.choice_msg is False:  # if no new messages repeat
            time.sleep(self.timeout)
            self.choice()


    def numb(self):
        self.readmsg()
        self.rpass = re.search(r"\'text\'\:\s\'\/([0-9]{1,6})\'", self.readlm)
        if self.repeat_numb_msg is False:  # send message if not yet send
            self.sendmsg('How many iterations do you want before increasing difficulty? (/[num]):')
            self.repeat_numb_msg = True
        if self.rpass:
            self.sendmsg(f"Have chosen {self.rpass.group(1)} iterations mode")
            self.numb_msg = True
            self.count()
        if self.numb_msg is False:  # if no new messages repeat
            time.sleep(self.timeout)
            self.numb()


    def count(self):
        if self.chosen == 'mul':
            if self.convert_rpass is False:  # convert pass var if not yet done
                self.rpass = int(self.rpass.group(1))
                self.convert_rpass = True
            if self.rpass == 1:  # for pass var of 1 we choose other approach
                if self.itera != 1:
                    if self.itera % 2 == 1:
                        self.mnum[0] += 1
                    else:
                        self.mnum[1] += 1
            else:
                if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                    self.mnum[0] += 1  # every 2 pass increase difficulty value
                elif self.itera % self.rpass == 1 and self.itera != 1:
                    self.mnum[1] += 1  # every 1 pass increase difficulty value
            tm.ml(self.mnum[0], self.mnum[1], mode='telegram', obj=self)
        elif self.chosen == 'div':
            if self.convert_rpass is False:  # convert pass var if not yet done
                self.rpass = int(self.rpass.group(1))
                self.convert_rpass = True
            if self.rpass == 1:  # for pass var of 1 we choose other approach
                if self.itera != 1:
                    if self.itera % 2 == 1:
                        self.dnum[1] += 1
                    else:
                        self.dnum[0] += 1
            else:
                if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                    self.dnum[1] += 1  # every 2 pass increase difficulty value
                elif self.itera % self.rpass == 1 and self.itera != 1:
                    self.dnum[0] += 1  # every 1 pass increase difficulty value
            tm.dl(self.dnum[0], self.dnum[1], mode='telegram', obj=self)
        self.itera += 1
        self.count()  # main recursion part is done here


pbot = Bot(token)  # init bot with token read from file
pbot.start()
