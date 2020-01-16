import re
import json
import requests
import time


import tmath as tm


with open('tok.conf', 'r') as config:
    token = config.read().split('|')[1]
    print(token)


class Bot():


    def __init__(self, tok):
        self.timeout = 1 
        self.itera = 1
        self.c = [ ]
        self.c1 = [ ]
        self.c2 = [ ]
        self.uc = [ ]
        self.uc1 = [ ]
        self.uc2 = [ ]
        self.mnum = [ 2, 1 ]
        self.dnum = [ 4, 2 ]
        self.convert_rpass = False
        self.convert_nitera = False
        self.count_msg = False
        self.choice_msg = False
        self.endl_msg = False
        self.numb_msg = False
        self.numb2_msg = False
        self.repeat_choice_msg = False
        self.repeat_count_msg = False
        self.repeat_endl_msg = False
        self.repeat_numb_msg = False
        self.repeat_numb2_msg = False
        self.url = "https://api.telegram.org/bot{}".format(tok)


    def readmsg(self):
        self.requp = self.url + "/getupdates"
        self.msgreq = requests.get(self.requp)
        self.listmsg = self.msgreq.json().get('result')
        self.readlm = str(self.listmsg[-1]).lower()


    def sendmsg(self, msg):
        self.chat_id = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", self.readlm).group(1)
        self.reqms = self.url + '/sendmessage?text={}&chat_id={}'.format(msg, self.chat_id)
        requests.get(self.reqms)


    def start(self):
        self.readmsg()
        if re.search(r'\/start', self.readlm):
            self.sendmsg("Started counting! Type /restart if you want to restart in same dialog!")
            self.count_msg = True
            self.choice()
        if self.count_msg is False:
            time.sleep(self.timeout)
            self.start()


    def restart(self):
        self.__init__(token)
        self.readlm = '/start'
        self.start()


    def choice(self):
        self.readmsg()
        if self.repeat_choice_msg is False:
            self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
            self.repeat_choice_msg = True
        if re.search(r"\'text\'\:\s\'\/mul\'", self.readlm):
            self.sendmsg("Multiplication is chosen")
            self.choice_msg = True
            self.chosen = "mul"
            self.numb()
        elif re.search(r"\'text\'\:\s\'\/div\'", self.readlm):
            self.sendmsg("Division is chosen")
            self.choice_msg = True
            self.chosen = "div"
            self.numb()
        elif re.search(r"\'text\'\:\s\'\/restart\'", self.readlm):
            self.restart()
        if self.choice_msg is False:
            time.sleep(self.timeout)
            self.choice()


    def numb(self):
        self.readmsg()
        self.rpass = re.search(r"\'text\'\:\s\'\/d([0-9]{1,6})\'", self.readlm)
        if self.repeat_numb_msg is False:
            self.sendmsg('How many iterations do you want before increasing difficulty? (/d[num]):')
            self.repeat_numb_msg = True
        if self.rpass:
            self.sendmsg('Have chosen {} iterations mode'.format(self.rpass.group(1)))
            self.numb_msg = True
            self.count()
        elif re.search(r"\'text\'\:\s\'\/restart\'", self.readlm):
            self.restart()
        if self.numb_msg is False:
            time.sleep(self.timeout)
            self.numb()


    def count(self):
        self.readmsg()
        if self.chosen == 'mul':
            if self.convert_rpass is False:
                self.rpass = int(self.rpass.group(1))
                self.convert_rpass = True
            if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                self.mnum[0] += 1
            elif self.itera % self.rpass == 1 and self.itera != 1:
                self.mnum[1] += 1
            tm.ml(self.mnum[0], self.mnum[1], mode='telegram', obj=self)
        elif self.chosen == 'div':
            if self.convert_rpass is False:
                self.rpass = int(self.rpass.group(1))
                self.convert_rpass = True
            if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                self.dnum[1] += 1
            elif self.itera % self.rpass == 1 and self.itera != 1:
                self.dnum[0] += 1
            tm.dl(self.dnum[0], self.dnum[1], mode='telegram', obj=self)
        self.itera += 1
        time.sleep(self.timeout)
        self.count()


pbot = Bot(token)
pbot.start()
