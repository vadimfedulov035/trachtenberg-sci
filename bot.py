import re
import json
import requests
import time



with open('tok.conf', 'r') as config:
    token = config.read().split('|')[0]
    print(token)


class Bot():
    
    def __init__(self, tok):
        self.count_msg = False
        self.choice_msg = False
        self.repeat_choice_msg = False
        self.repeat_count_msg = False
        self.url = "https://api.telegram.org/bot{}".format(tok)

    def readmsg(self):
        self.requp = self.url + "/getupdates?"
        self.msgreq = requests.get(self.requp)
        self.msg = self.msgreq.json().get('result')
        self.lmsg = self.msg[-1]
        self.readlm = str(self.lmsg).lower()
        if self.count_msg is False: 
            self.count()

    def count(self):
        self.start = self.readlm.find('/count')
        if self.count_msg is False and self.repeat_count_msg is False:
            self.sendmsg('Hello! Type /count to practice in counting!')
            self.repeat_count_msg = True
        if self.start == -1:
            pass
        elif self.start != -1 and self.count_msg is False:
            self.sendmsg("Started counting!")
            self.count_msg = True
            self.choice()
        if self.count_msg is False:
            time.sleep(1)
            self.readmsg()
            self.count()

    def choice(self):
        if self.choice_msg is False and self.repeat_choice_msg is False:
            self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
            self.repeat_choice_msg = True
        if (self.readlm.find('/mul') != -1 or self.readlm.find('/div') != -1) and self.repeat_choice_msg is False:
            self.sendmsg("Okay, that's it") 
        if self.readlm.find('/mul') != -1:
            self.sendmsg("Multiplication is chosen")
            self.choice_msg = True
        if self.readlm.find('/div') != -1:
            self.sendmsg("Division is chosen")
            self.choice_msg = True
        if self.choice_msg is False:
            time.sleep(1)
            self.readmsg()
            self.choice()

    def sendmsg(self, msg):
        self.chat_id = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{10})", self.readlm).group(1)
        self.reqms = self.url + '/sendmessage?text={}&chat_id={}'.format(msg, self.chat_id)
        requests.get(self.reqms)

pbot = Bot(token)
while True:
    pbot.readmsg()
