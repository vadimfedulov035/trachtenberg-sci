import re
import json
import requests
import time



with open('tok.conf', 'r') as config:
    token = config.read().split('|')[1]
    print(token)


class Bot():


    def __init__(self, tok):
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
        self.i = 0
        self.requp = self.url + "/getupdates"
        self.msgreq = requests.get(self.requp)
        self.listmsg = self.msgreq.json().get('result')
        for msg in self.listmsg:
            self.found = re.search(r"\'date\':\s([0-9]{10})\,", str(msg)).group(1)
            if self.i == 0:
                self.neededit = self.i
                self.date = self.found
            elif self.i > 0:
                if self.found > self.date:
                    self.neededit = self.i
            self.i += 1
        self.readlm = str(self.listmsg[-1]).lower()
        print(self.readlm)


    def sendmsg(self, msg):
        self.chat_id = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{10})", self.readlm).group(1)
        self.reqms = self.url + '/sendmessage?text={}&chat_id={}'.format(msg, self.chat_id)
        requests.get(self.reqms)


    def count(self):
        self.readmsg()
        if self.repeat_count_msg is False:
            self.sendmsg('Hello! Type /count to practice in counting!')
            self.repeat_count_msg = True
            print(self.readmsg)
        if re.search(r'\/count', self.readlm):
            self.sendmsg("Started counting!")
            self.count_msg = True
            self.choice()
        if self.count_msg is False:
            time.sleep(1)
            self.count()


    def choice(self):
        self.readmsg()
        if self.repeat_choice_msg is False:
            self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
            self.repeat_choice_msg = True
        if re.search(r'\/mul', self.readlm) is not None:
            self.sendmsg("Multiplication is chosen")
            self.choice_msg = True
            self.chosen = "mul"
            self.endl()
        elif re.search(r'\/div', self.readlm) is not None:
            self.sendmsg("Division is chosen")
            self.choice_msg = True
            self.chosen = "div"
            self.endl()
        if self.choice_msg is False:
            time.sleep(1)
            self.choice()


    def endl(self):
        self.readmsg()
        if self.repeat_endl_msg is False:
            self.sendmsg("Do you want to be in endless mathematical loop? (/yes or /no)")
            self.repeat_endl_msg = True
        if re.search(r'\/yes', self.readlm) is not None:
            self.sendmsg('Loop mode is chosen')
            self.endl_msg = True
            self.numb2()
        elif re.search(r'\/no', self.readlm) is not None:
            self.sendmsg('Finite mode is chosen')
            self.endl_msg = True
            self.numb()
        if self.endl_msg is False:
            time.sleep(1)
            self.endl()


    def numb(self):
        self.readmsg()
        self.rpass = re.search(r'\/d([0-9]{1,6})', self.readlm)
        if self.repeat_numb_msg is False:
            self.sendmsg('How many iterations do you want before increasing difficulty? (/d{num}):')
            self.repeat_numb_msg = True
        if self.rpass is not None:
            self.sendmsg('Have chosen {} iterations mode'.format(self.rpass.group(1)))
            self.numb_msg = True
            self.numb2()
        if self.numb_msg is False:
            time.sleep(1)
            self.numb()


    def numb2(self):
        self.readmsg()
        self.nitera = re.search(r'\/t([0-9]{1,6})', self.readlm)
        if self.repeat_numb2_msg is False:
            self.sendmsg('How many iterations do you want to pass? (/t{num})')
            self.repeat_numb2_msg = True
        if self.nitera is not None:
            self.sendmsg('You have chosen {} iterations total'.format(self.nitera.group(1)))
            self.numb2_msg = True
        if self.numb2_msg is False:
            time.sleep(1)
            self.numb2()



pbot = Bot(token)
pbot.count()
