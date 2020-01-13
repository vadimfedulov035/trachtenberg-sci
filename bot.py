import re
import json
import requests
import time



with open('tok.conf', 'r') as config:
    token = config.read().split('|')[0]
    print(token)


class Bot():
    
    def __init__(self, tok):
        self.counter = False
        self.url = "https://api.telegram.org/bot{}".format(tok)

    def readmsg(self):
        self.update = self.url + "/getupdates?"
        self.msgreq = requests.get(self.update)
        self.msg = self.msgreq.json().get('result')
        self.lmsg = self.msg[-1]
        self.readlm = str(self.lmsg).lower()
        if self.counter is not True:
            self.count()

    def count(self):
        self.start = self.readlm.find('/count')
        if self.start == -1:
            pass
        elif self.start != -1 and self.counter is not True:
            print("Started counting!")
            self.sendmsg("Started counting!")
            self.counter = True
            self.choice()

    def choice(self):
        self.readmsg()
        self.sendmsg("Do you want a division test or multiplication? (/mul or /div):")
        if self.readlm.find('/mul') == -1 or self.readlm.find('/div') == -1:
            self.sendmsg("Okay, that's it") 
        else:
            self.sendmsg("You chose nothing!")
        if self.readlm.find('/mul') == -1:
            print("Multiplication is chosen")
        if self.readlm.find('/div') == -1:
            print("Division is chosen")

    def sendmsg(self, msg):
        self.chat_id = re.search(r"\'chat\'\:\s\{\'id\'\:\s([0-9]{10})", self.readlm).group(1)
        self.reqms = self.url + '/sendmessage?text={}&chat_id={}'.format(msg, self.chat_id)
        requests.get(self.reqms)


pbot = Bot(token)
while True:
    pbot.readmsg()
