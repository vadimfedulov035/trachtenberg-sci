import os
import urllib.request
import urllib.error
import itertools
import json


try:
    os.mknod("cids.log")  # create cids.log file
except FileExistsError:
    pass

with open("token.conf", "r") as config:
    token = config.read().rstrip()


"""DECLARATION BLOCK"""
cdef str URL = f"https://api.telegram.org/bot{token}/getupdates"
cdef list cids, pcids
cids, pcids = [], []


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
    for n in itertools.count():
        try:
            cid = js["result"][n]["message"]["chat"]["id"]
            if str(cid) not in cids:
                cids.append(str(cid))
        except IndexError:
            break

    with open("cids.log", "r") as ptl:
        pcids = ptl.read().split("\n")

    with open("cids.log", "a") as tl:
        for cid in cids:
            if cid not in pcids:
                tl.write(f"{cid}\n")
