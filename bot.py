import json
import requests
import time


with open('tok.conf', 'r') as config:
    token = config.read().split('|')[0]
    print(token)


class Bot():
    
    def __init__(self, tok):
        self.url = "https://api.telegram.org/bot{}".format(tok)
        self.msg = None

    def update(self, time=None):
        self.update = self.url + "/getupdates"
        self.msgreq = requests.get(self.update)
        self.msg = self.msgreq.json().get('result')
        self.lmsg = self.msg[-1]
        self.start()
        
    def start(self):
        self.start = str(self.lmsg).lower().find('startcount')
        if self.start == -1:
            pass
        elif self.start != -1:
            print("Started counting")

while True:
    bot = Bot(token)
    bot.update()
    time.sleep(5)
