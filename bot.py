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
        self.itera = 0
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


    def sendmsg(self, messg):
        self.chat_id = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{8,12})", self.readlm).group(1)
        self.reqms = self.url + '/sendmessage?text={msg}&chat_id={cid}'.format(msg=messg, cid=self.chat_id)
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
        self.__init__()
        self.start()


    def choice(self):
        self.readmsg()
        if self.repeat_choice_msg is False:
            self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
            self.repeat_choice_msg = True
        if re.search(r'\/mul', self.readlm):
            self.sendmsg("Multiplication is chosen")
            self.choice_msg = True
            self.chosen = "mul"
            self.endl()
        elif re.search(r'\/div', self.readlm):
            self.sendmsg("Division is chosen")
            self.choice_msg = True
            self.chosen = "div"
            self.endl()
        elif re.search('r\/restart', self.readlm):
            self.restart()
        if self.choice_msg is False:
            time.sleep(self.timeout)
            self.choice()


    def endl(self):
        self.readmsg()
        if self.repeat_endl_msg is False:
            self.sendmsg("Do you want to be in endless mathematical loop? (/yes or /no)")
            self.repeat_endl_msg = True
        if re.search(r'\/yes', self.readlm):
            self.sendmsg('Loop mode is chosen')
            self.endl_msg = True
            self.infinite = True
            self.numb()
        elif re.search(r'\/no', self.readlm):
            self.sendmsg('Finite mode is chosen')
            self.endl_msg = True
            self.infinite = False
            self.numb()
        elif re.search('r\/restart', self.readlm):
            self.restart()
        if self.endl_msg is False:
            time.sleep(self.timeout)
            self.endl()


    def numb(self):
        self.readmsg()
        self.rpass = re.search(r'\/d([0-9]{1,6})', self.readlm)
        if self.repeat_numb_msg is False:
            self.sendmsg('How many iterations do you want before increasing difficulty? (/d{num}):')
            self.repeat_numb_msg = True
        if self.rpass:
            self.sendmsg('Have chosen {rpass} iterations mode'.format(rpass=self.rpass.group(1)))
            self.numb_msg = True
            if not self.infinite:
                self.numb2()
            else:
                self.count()
        elif re.search('r\/restart', self.readlm):
            self.restart()
        if self.numb_msg is False:
            time.sleep(self.timeout)
            self.numb()


    def numb2(self):
        self.readmsg()
        self.nitera = re.search(r'\/t([0-9]{1,6})', self.readlm)
        if self.repeat_numb2_msg is False:
            self.sendmsg('How many iterations do you want to pass? (/t{num})')
            self.repeat_numb2_msg = True
        if self.nitera is not None:
            self.sendmsg('You have chosen {nit} iterations total'.format(nit=self.nitera.group(1)))
            self.numb2_msg = True
        elif re.search('r\/restart', self.readlm):
            self.restart()
        if self.numb2_msg is False:
            time.sleep(self.timeout)
            self.numb2()


    def count(self):
        self.rpass = int(self.rpass.group(1))
        self.nitera = int(self.nitera.group(1))
        if self.chosen == 'mul':
            if self.convert_rpass is False:
                self.rpass = int(self.rpass.group(1))
                self.convert_rpass = True
            if self.infinite:
                if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                    self.mnum[0] += 1
                elif self.itera % self.rpass == 1 and self.itera != 1:
                    self.mnum[1] += 1
                ml(self.mnum[0], self.mnum[1], mode='telegram', obj=self)
                self.count()
            else:
                if self.convert_nitera is False:
                    self.nitera = int(self.nitera.group(1))
                    self.convert_nitera = True
                if self.nitera == self.itera:
                    self.restart()
                elif self.itera % (self.rpass * 2) == 2 and self.itera != 1:
                    self.mnum[1] += 1
                elif self.itera % rpass == 1 and self.itera != 1:
                    self.mnum[0] += 1
                tm.ml(self.mnum[0], self.num[1], mode='telegram', obj=self)
                self.count()
        elif self.chosen == 'div':
            if self.infinite:
                if self.itera % (self.rpass * 2) == 1 and self.itera != 1:
                    self.dnum[0] += 1
                elif self.itera % self.rpass == 1 and self.itera != 1:
                    self.num[1] += 1
                tm.dl(self.num[0], self.num[1], mode='telegram', obj=self)
                self.count()
            else:
                if self.convert_nitera is False:
                    self.nitera = int(self.nitera.group(1))
                    self.convert_nitera = True
                if self.nitera == self.itera:
                    self.restart()
                elif self.itera % (self.rpass * 2) == 2 and self.itera != 1:
                    self.num[1] += 1
                elif self.itera % rpass == 1 and self.itera != 1:
                    self.num[0] += 1
                tm.dl(self.num[0], self.num[1], mode='telegram', obj=self)
                self.count()
        self.itera += 1
        self.count()


pbot = Bot(token)
pbot.start()
