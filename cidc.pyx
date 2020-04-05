import urllib.request
import urllib.error
import json
import time


"""DECLARATION BLOCK"""
cdef str token
cdef str URL
cdef list cids, pcids
pcids, cids = [], []


with open("tok.conf", "r") as f:
    token = f.read().rstrip()


URL = f"https://api.telegram.org/bot{token}/getupdates"


while True:
    try:
        mreq = urllib.request.urlopen(URL)
    except (urllib.error.URLError, urllib.error.HTTPError):
        continue
    rj = mreq.read()
    try:
        js = json.loads(rj.decode("utf-8"))
    except json.decoder.JSONDecodeError:
        continue
    """parsing loop through all cids"""
    for n in range(100):
        try:
            cid = js["result"][n]["message"]["chat"]["id"]
            cids = []
            if str(cid) not in cids:
                cids.append(str(cid))
        except IndexError:
            break
    with open("cids.log", "r") as f:
        pcids = f.read().rstrip().split("\n")
    with open("cids.log", "a") as f:
        for cid in cids:
            if cid not in pcids:
                f.write(f"{cid}\n")

    time.sleep(0.25)
