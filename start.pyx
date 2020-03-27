#cython: language_level=3
import re
import random
import asyncio
import itertools
import json
import urllib.error, urllib.request, urllib.parse
import asyncio
import numpy as np


with open("token.conf", "r") as config:
    token = config.read().rstrip()


async def ml(multiplicand, multiplier, obj):
    """Arithmetics operation: Multiplication"""
    x1, y1 = 1, 1
    x2, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    a = random.randint(x1, y1)
    b = random.randint(x2, y2)
    if a in {0, 1, 2} or b in {0, 1, 2}:  # if got 0, 1, 2 to multiply - skip
        await ml(multiplicand, multiplier, obj=obj)
    c = a * b
    if c == obj.c:  # if got the same answer restart
        await ml(multiplicand, multiplier, obj=obj)
    obj.c = c  # record answer
    try:
        await obj.sndmsg(f"{a} * {b} = ?")
    except ConnectionError:
        await ml(multiplicand, multiplier, obj=obj)
    obj.prevmsg = obj.readlmsg
    while True:
        await asyncio.sleep(obj.TIMEOUT)
        try:
            await obj.readmsg()
        except ConnectionError:
            continue
        if obj.readlmsg == "/start":  # check for restart msg
            await obj.restart()
        elif obj.readlmsg == obj.prevmsg:  # check for novelty
            continue
        else:
            try:  # to extract num from latest msg
                uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                uc = int(uc[0])
            except IndexError:
                if obj.lang == "en":
                    await obj.sndmsg(obj.MISTYPE_EN)
                elif obj.lang == "ru":
                    await obj.sndmsg(obj.MISTYPE_RU)
                obj.prevmsg = obj.readlmsg
                continue
        if uc == obj.uc:
            continue  # if got old msg try again
        obj.uc = uc  # record user answer
        """compare user answers against right ones"""
        if uc == c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg("You're God Damn right!")
                elif obj.lang == "ru":
                    await obj.sndmsg("Вы чертовски правы!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg(f"No, right answer is {c}!")
                elif obj.lang == "ru":
                    await obj.sndmsg(f"Нет, правильный ответ {c}!")
            except ConnectionError:
                continue
            break


async def dl(dividend, divider, obj):
    """Arithmetics operation: Division"""
    x1, y1 = 1, 1
    x2, y2 = 1, 1
    for i in range(dividend - 1):
        x1 *= 10
    for i in range(dividend):
        y1 *= 10
    for i in range(divider - 1):
        x2 *= 10
    for i in range(divider):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    a = random.randint(x1, y1)
    b = random.randint(x2, y2)
    c1 = a // b
    c2 = a % b
    if c1 == obj.c1 or c2 == obj.c2:  # if got the same answer restart
        await dl(dividend, divider, obj=obj)
    obj.c1, obj.c2 = c1, c2  # record answers
    try:
        await obj.sndmsg(f"{a} // | % {b} = ?")
    except ConnectionError:
        await dl(dividend, divider, obj=obj)
    obj.prevmsg = obj.readlmsg
    while True:
        await asyncio.sleep(obj.TIMEOUT)
        try:
            await obj.readmsg()
        except ConnectionError:
            continue
        if obj.readlmsg == "/start":  # check for restart msg
            await obj.restart()
        elif obj.readlmsg == obj.prevmsg:  # check for novelty
            continue
        else:
            try:  # to extract nums from latest msg
                uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                uc1, uc2 = int(uc[0]), int(uc[1])
            except IndexError:
                if obj.lang == "en":
                    await obj.sndmsg(obj.MISTYPE_EN)
                elif obj.lang == "ru":
                    await obj.sndmsg(obj.MISTYPE_RU)
                obj.prevmsg = obj.readlmsg
                continue
        if uc1 == obj.uc1 and uc2 == obj.uc2:
            continue  # if got old msg try again
        obj.uc1, obj.uc2 = uc1, uc2  # record user answers
        """compare user answers against right ones"""
        if uc1 == c1 and uc2 == c2:
            try:
                if obj.lang == "en":
                    await obj.sndmsg("You're God Damn right!")
                elif obj.lang == "ru":
                    await obj.sndmsg("Вы чертовски правы!")
            except ConnectionError:
                continue
            break
        else:
            if obj.lang == "en":
                m1 = f"No, right answer is {c1} "
                m2 = f"with residual of {c2}!"
            elif obj.lang == "ru":
                m1 = f"Нет, правильный ответ это {c1} "
                m2 = f"с остатком {c2}!"
            msg = m1 + m2
            try:
                await obj.sndmsg(msg)
            except ConnectionError:
                continue
            break


async def sqr(sqrn, obj):
    """Arithmetics operation: Squaring"""
    x1, y1 = 1, 1
    for i in range(sqrn - 1):
        x1 *= 10
    for i in range(sqrn):
        y1 *= 10
    y1 -= 1
    a = random.randint(x1, y1)
    if a in {0, 1, 2}:  # if got 0, 1, 2 to multiply - skip
        await sqrn(sqrn, obj=obj)
    c = a ** 2
    if c == obj.c:
        await sqr(sqrn, obj=obj)
    obj.c = c
    try:
        await obj.sndmsg(f"{a} ** 2 = ?")
    except ConnectionError:
        await sqr(sqrn, obj=obj)
    obj.prevmsg = obj.readlmsg
    while True:
        await asyncio.sleep(obj.TIMEOUT)
        try:
            await obj.readmsg()
        except ConnectionError:
            continue
        if obj.readlmsg == "/start":  # check for restart msg
            await obj.restart()
        elif obj.readlmsg == obj.prevmsg:  # check for novelty
            continue
        else:
            try:  # to extract num from latest msg
                uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                uc = int(uc[0])
            except IndexError:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(obj.MISTYPE_EN)
                    elif obj.lang == "ru":
                        await obj.sndmsg(obj.MISTYPE_RU)
                except ConnectionError:
                    continue
                obj.prevmsg = obj.readlmsg
                continue
        if uc == obj.uc:
            continue  # if got old msg try again
        obj.uc = uc  # record user answer
        """compare user answers against right ones"""
        if uc == c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg("You're God Damn right!")
                elif obj.lang == "ru":
                    await obj.sndmsg("Вы чертовски правы!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg(f"No, right answer is {c}!")
                elif obj.lang == "ru":
                    await obj.sndmsg(f"Нет, правильный ответ {c}!")
            except ConnectionError:
                continue
            break


async def root(rootn, obj):
    """Arithmetics operation: Square Root taking"""
    x1, y1 = 1, 1
    for i in range(root - 1):
        x1 *= 10
    for i in range(root):
        y1 *= 10
    y1 -= 1
    a = random.randint(x1, y1)
    b = a ** 2
    c = b ** 0.5
    if c == obj.c:
        await root(root, obj)
    obj.c = c
    try:
        await obj.sndmsg(f"{b} ** 0.5 = ?")
    except ConnectionError:
        await root(root, obj=obj)
    obj.prevmsg = obj.readlmsg
    while True:
        await asyncio.sleep(obj.TIMEOUT)
        await obj.readmsg()
        if obj.readlmsg == "/start":  # check for restart msg
            await obj.restart()
        elif obj.readlmsg == obj.prevmsg:  # check for novelty
            continue
        else:
            try:  # to extract nums from latest msg
                uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                uc = int(uc[0])
            except IndexError:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(obj.MISTYPE_EN)
                    elif obj.lang == "ru":
                        await obj.sndmsg(obj.MISTYPE_RU)
                except ConnectionError:
                    continue
                obj.prevmsg = obj.readlmsg
                continue
        if uc == obj.uc:
            continue  # if got old msg try again
        obj.uc = uc  # record user answer
        """compare user answers against right ones"""
        if uc == c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg("You're God Damn right!")
                elif obj.lang == "ru":
                    await obj.sndmsg("Вы чертовски правы!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                if obj.lang == "en":
                    await obj.sndmsg(f"No, right answer is {int(c)}!")
                elif obj.lang == "ru":
                    await obj.sndmsg(f"Нет, правильный ответ {int(c)}!")
            except ConnectionError:
                continue
            break


async def vml(multiplicand, multiplier, matrix, obj):
    """Linear Algebra operation: vector-matrix multiplication"""
    x1, y1 = 1, 1
    x2, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    """SPECIFICATION BLOCK"""
    """non-static vars for basic matricies specification"""
    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    if matrix == 2:  # here we don't need to specify more vars
        a = np.array([[a1, b1],
                      [a2, b2]])
        b = np.array([[l1],
                      [l2]])
    elif matrix == 3:  # here we need to specify more vars
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        a3 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        l3 = random.randint(x2, y2)
        a = np.array([[a1, b1, c1],
                      [a2, b2, c2],
                      [a3, b3, c3]])
        b = np.array([[l1],
                      [l2],
                      [l3]])
    elif matrix == 4:  # here we specify more vars depending on choice
        choices = ["2x3", "3x2"]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
        if matrix == 4 and fch == "2x3":
            c1 = random.randint(x1, y1)
            c2 = random.randint(x1, y1)
            l3 = random.randint(x2, y2)
            a = np.array([[a1, b1, c1],
                          [a2, b2, c2]])
            b = np.array([[l1],
                          [l2],
                          [l3]])
        elif matrix == 4 and fch == "3x2":
            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)
            a = np.array([[a1, b1],
                          [a2, b2],
                          [a3, b3]])
            b = np.array([[l1],
                          [l2]])
    c = np.matmul(a, b)
    """COUNTING BLOCK"""
    if matrix == 2 or matrix == 4 and fch == "2x3":
        c1, c2 = c[0], c[1]
        if c1 == obj.c1 or c2 == obj.c2:
            await vml(multiplicand, multiplier, obj=obj)
        obj.c1, obj.c2 = c1, c2
        try:
            await obj.sndmsg(f"{a}\n*****\n{b}\n=====\n?????")
        except ConnectionError:
            await vml(multiplicand, multiplier, matrix=matrix, obj=obj)
        obj.prevmsg = obj.readlmsg
        while True:
            try:
                await obj.readmsg()
            except ConnectionError:
                continue
            if obj.readlmsg == "/start":  # check for restart msg
                await obj.restart()
            elif obj.readlmsg == obj.prevmsg:  # check for novelty
                continue
            else:
                try:  # to extract nums from latest msg
                    uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                    uc1, uc2 = int(uc[0]), int(uc[1])
                except IndexError:
                    if obj.lang == "en":
                        await obj.sndmsg(obj.MISTYPE_EN)
                    elif obj.lang == "ru":
                        await obj.sndmsg(obj.MISTYPE_RU)
                    obj.prevmsg = obj.readlmsg
                    continue
            if uc1 == obj.uc1 and uc2 == obj.uc2:
                continue  # if got old msg try again
            obj.uc1, obj.uc2 = uc1, uc2  # if got new msg work with nums
            """compare user answers against right ones"""
            if uc1 == c1 and uc2 == c2:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg("You're God Damn right!")
                    elif obj.lang == "ru":
                        await obj.sndmsg("Вы чертовски правы!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(f"No, right answer is\n{c}!")
                    elif obj.lang == "ru":
                        await obj.sndmsg(f"Нет, правильный ответ\n{c}!")
                except ConnectionError:
                    continue
                break
    elif matrix == 3 or matrix == 4 and fch == "3x2":
        c1, c2, c3 = c[0], c[1], c[2]
        if c1 == obj.c1 or c2 == obj.c2 or c3 == obj.c3:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        obj.c1, obj.c2, obj.c3 = c1, c2, c3  # record answers
        try:
            await obj.sndmsg(f"{a}\n*****\n{b}\n=====\n?????")
        except ConnectionError:
            await vml(multiplicand, multiplier, obj)
        obj.c1, obj.c2 = c1, c2
        obj.prevmsg = obj.readlmsg
        while True:
            await asyncio.sleep(obj.TIMEOUT)
            try:
                await obj.readmsg()
            except ConnectionError:
                continue
            if obj.readlmsg == "/start":  # check for restart msg
                await obj.restart()
            elif obj.readlmsg == obj.prevmsg:  # check for novelty
                continue
            else:
                try:  # to extract nums from latest msg
                    uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                    uc1, uc2, uc3 = int(uc[0]), int(uc[1]), int(uc[2])
                except IndexError:
                    try:
                        if obj.lang == "en":
                            await obj.sndmsg(obj.MISTYPE_EN)
                        elif obj.lang == "ru":
                            await obj.sndmsg(obj.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    obj.prevmsg = obj.readlmsg
                    continue
            if uc1 == obj.uc1 and uc2 == obj.uc2 and uc3 == obj.uc3:
                continue  # if got old msg try again
            obj.uc1, obj.uc2, obj.uc3 = uc1, uc2, uc3  # record user answer
            """compare user answers against right ones"""
            if uc1 == c1 and uc2 == c2 and uc3 == c3:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg("You're God Damn right!")
                    elif obj.lang == "ru":
                        await obj.sndmsg("Вы чертовски правы!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(f"No, right answer is\n{c}!")
                    elif obj.lang == "ru":
                        await obj.sndmsg(f"Нет, правильный ответ\n{c}!")
                except ConnectionError:
                    continue
                break


async def mml(multiplicand, multiplier, matrix, obj):
    """Linear Algebra operation: matrix-matrix multiplication"""
    x1, y1 = 1, 1
    x2, y2 = 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    """SPECIFICATION BLOCK"""
    """non-static vars for basic matricies specification"""
    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    q1 = random.randint(x2, y2)
    q2 = random.randint(x2, y2)
    if matrix == 2:  # here we don't need to specify more vars
        a = np.array([[a1, b1],
                      [a2, b2]])
        b = np.array([[l1, q1],
                      [l2, q2]])
    elif matrix == 3:  # here we need to specify more vars
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        s1 = random.randint(x2, y2)
        s2 = random.randint(x2, y2)
        a3 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        l3 = random.randint(x2, y2)
        q3 = random.randint(x2, y2)
        s3 = random.randint(x2, y2)
        a = np.array([[a1, b1, c1],
                      [a2, b2, c2],
                      [a3, b3, c3]])
        b = np.array([[l1, q1, s1],
                       [l2, q2, s2],
                       [l3, q3, s3]])
    elif matrix == 4:  # here we specify more vars depending on choice
        choices = ["2x3", "3x2"]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
        if matrix == 4 and fch == "2x3":
            c1 = random.randint(x2, y2)
            c2 = random.randint(x2, y2)
            l3 = random.randint(x2, y2)
            q3 = random.randint(x2, y2)
            a = np.array([[a1, b1, c1],
                          [a2, b2, c2]])
            b = np.array([[l1, q1],
                          [l2, q2],
                          [l3, q3]])
        elif matrix == 4 and fch == "3x2":
            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)
            s1 = random.randint(x2, y2)
            s2 = random.randint(x2, y2)
            a = np.array([[a1, b1],
                          [a2, b2],
                          [a3, b3]])
            b = np.array([[l1, q1, s1],
                          [l2, q2, s2]])
    c = np.matmul(a, b)
    """COUNTING BLOCK"""
    if matrix == 2 or matrix == 4 and fch == "2x3":
        c1, c2, c3, c4 = c[0, 0], c[0, 1], c[1, 0], c[1, 1]
        if c1 == obj.c1 or c2 == obj.c2:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        elif c3 == obj.c3 or c4 == obj.c4:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        obj.c1, obj.c2 = c1, c2
        obj.c3, obj.c4 = c3, c4
        try:
            await obj.sndmsg(f"{a}\n*****\n{b}\n=====\n?????")
        except ConnectionError:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        obj.prevmsg = obj.readlmsg
        while True:
            await asyncio.sleep(obj.TIMEOUT)
            try:
                await obj.readmsg()
            except ConnectionError:
                continue
            if obj.readlmsg == "/start":  # check for restart msg
                await obj.restart()
            elif obj.readlmsg == obj.prevmsg:  # check for novelty
                continue
            else:
                try:  # to extract nums from latest msg
                    uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                    uc1, uc2 = int(uc[0]), int(uc[1])
                    uc3, uc4 = int(uc[2]), int(uc[3])
                except IndexError:
                    try:
                        if obj.lang == "en":
                            await obj.sndmsg(obj.MISTYPE_EN)
                        elif obj.lang == "ru":
                            await obj.sndmsg(obj.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    obj.prevmsg = obj.readlmsg
                    continue
            if uc1 == obj.uc1 and uc2 == obj.uc2:
                continue  # if got old msg try again
            elif uc3 == obj.uc3 and uc4 == obj.uc4:
                continue  # if got old msg try again
            obj.uc1, obj.uc2 = uc1, uc2  # record user answers
            obj.uc3, obj.uc4 = uc3, uc4  # record user answers
            """compare user answers against right ones"""
            if uc1 == c1 and uc2 == c2 and uc3 == c3 and uc4 == c4:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg("You're God Damn right!")
                    elif obj.lang == "ru":
                        await obj.sndmsg("Вы чертовски правы!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(f"No, right answer is\n{c}!")
                    elif obj.lang == "ru":
                        await obj.sndmsg(f"Нет, правильный ответ\n{c}!")
                except ConnectionError:
                    continue
                break
    elif matrix == 3 or matrix == 4 and fch == "3x2":
        c1, c2, c3 = c[0, 0], c[0, 1], c[0, 2]
        c4, c5, c6 = c[1, 0], c[1, 1], c[1, 2]
        c7, c8, c9 = c[2, 1], c[2, 1], c[2, 2]
        if c1 == obj.c1 or c2 == obj.c2 or c3 == obj.c3:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        elif c4 == obj.c4 or c5 == obj.c5 or c6 == obj.c6:
            await mml(multiplicand, multiplier, matrix=matrix, obj=obj)
        obj.c1, obj.c2, obj.c3 = c1, c2, c3  # record answers
        obj.c4, obj.c5, obj.c6 = c4, c5, c6  # record answers
        obj.c7, obj.c8, obj.c9 = c7, c8, c9  # record answers
        await obj.sndmsg(f"{a}\n*****\n{b}\n=====\n?????")
        obj.prevmsg = obj.readlmsg
        while True:
            await asyncio.sleep(obj.TIMEOUT)
            try:
                await obj.readmsg()
            except ConnectionError:
                continue
            if obj.readlmsg == "/start":  # check for restart msg
                await obj.restart()
            elif obj.readlmsg == obj.prevmsg:  # check for novelty
                continue
            else:
                try:  # to extract nums from latest msg
                    uc = re.findall(r"([0-9]{1,10})", obj.readlmsg)
                    uc1, uc2, uc3 = int(uc[0]), int(uc[1]), int(uc[2])
                    uc4, uc5, uc6 = int(uc[3]), int(uc[4]), int(uc[5])
                    uc7, uc8, uc9 = int(uc[6]), int(uc[7]), int(uc[8])
                except IndexError:
                    try:
                        if obj.lang == "en":
                            await obj.sndmsg(obj.MISTYPE_EN)
                        elif obj.lang == "ru":
                            await obj.sndmsg(obj.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    obj.prevmsg = obj.readlmsg
                    continue
            if uc1 == obj.uc1 and uc2 == obj.uc2 and uc3 == obj.uc3:
                continue  # if got old msg try again
            elif uc4 == obj.uc4 and uc5 == obj.uc5 and uc6 == obj.uc6:
                continue  # if got old msg try again
            elif uc7 == obj.uc7 and uc8 == obj.uc8 and uc9 == obj.uc9:
                continue  # if got old msg try again
            obj.uc1, obj.uc2, obj.uc3 = uc1, uc2, uc3  # record user answers
            obj.uc4, obj.uc5, obj.uc5 = uc4, uc5, uc6  # record user answers
            obj.uc7, obj.uc8, obj.uc9 = uc7, uc8, uc9  # record user answers
            """compare user answers against right ones"""
            if uc1 == c1 and uc2 == c2 and uc3 == c3:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg("You're God Damn right!")
                    elif obj.lang == "ru":
                        await obj.sndmsg("Вы чертовски правы!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    if obj.lang == "en":
                        await obj.sndmsg(f"No, right answer is\n{c}!")
                    elif obj.lang == "ru":
                        await obj.sndmsg(f"Нет, правильный ответ\n{c}!")
                except ConnectionError:
                    continue
                break


cdef class Bot():
    cdef public str TOKEN
    cdef public int NUMBER
    cdef public int CID
    cdef public float TIMEOUT
    cdef public str URL, URLR, ERROR_EN, ERROR_RU, MISTYPE_EN, MISTYPE_RU
    cdef public int c, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cdef public int uc, uc1, uc2, uc3, uc4, uc5, uc6, uc7, uc8, uc9
    cdef public str prevmsg, readlmsg
    cdef public int start_msg, choice_msg, numb_msg, chm_msg, msized_msg, ch_cmod
    cdef public int restart_ch, fmul, fdiv, fvmul, fmmul, fsqr, froot
    cdef public int pdate, ldate, date
    cdef public list mnum, dnum, vmnum, mmnum
    cdef public int sqnum, ronum
    cdef public str lang, chosen
    cdef public int rpass, msize

    def __init__(self, tok, num):
        """static variables are defined here for correct start up"""
        self.TOKEN = tok  # token for connection to API
        self.NUMBER = num  # num serves as enumerator of cid later
        self.TIMEOUT = 0.01  # serves as placeholder for switching
        self.URL = f"https://api.telegram.org/bot{self.TOKEN}"
        self.URLR = self.URL + "/getupdates"
        self.ERROR_EN = "Sorry, I don't understand you, I will restart dialog!"
        self.ERROR_RU = "Извините, я не понимаю вас, я начну диалог с начала!"
        self.MISTYPE_EN = "Sorry, I didn't understand you, type more clearly!"
        self.MISTYPE_RU = "Извините, я не понимаю вас, печатайте чётче!"
        """non-static variables are defined here for further work"""
        self.date = 0  # date set to zero will serve in expression as starter
        self.prevmsg = "None" 
        self.c, self.uc = 0, 0
        self.c1, self.c2, self.c3 = 0, 0, 0
        self.c4, self.c5, self.c6 = 0, 0, 0
        self.c7, self.c8, self.c9 = 0, 0, 0
        self.uc1, self.uc2, self.uc3 = 0, 0, 0
        self.uc4, self.uc5, self.uc6 = 0, 0, 0
        self.uc7, self.uc8, self.uc9 = 0, 0, 0
        self.mnum = [2, 1]
        self.dnum = [4, 2]
        self.vmnum = [1, 1]
        self.mmnum = [1, 1]
        self.sqnum = 2
        self.ronum = 2
        self.start_msg = False
        self.choice_msg = False
        self.numb_msg = False
        self.chm_msg = False
        self.msized_msg = False
        self.ch_cmod = True
        self.restart_ch = False
        self.fmul = True
        self.fdiv = True
        self.fvmul = True
        self.fmmul = True
        self.fsqr = True
        self.froot = True

    async def readmsg(self):
        await asyncio.sleep(self.TIMEOUT)
        """new reqest to get fresh json data"""
        try:
            msgreq = urllib.request.urlopen(self.URLR)
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError
        rj = msgreq.read()
        try:
            js = json.loads(rj.decode("utf-8"))
        except json.decoder.JSONDecodeError:
            raise ConnectionError
        """set offset for bulk deletion of old messages"""
        if len(js["result"]) == 100:
            upd_id = js["result"][99]["update_id"]
            try:
                urllib.request.urlopen(f"{self.URLR}?offset={self.upd_id}")
            except (urllib.error.URLError, urllib.error.HTTPError):
                raise ConnectionError
        """loop through json to find last message by date"""
        for j in js["result"]:
            cid = j["message"]["chat"]["id"]
            if cid == self.CID:  # check date only if CID in msg matches
                date = j["message"]["date"]
                if date >= self.date:
                    self.ldate = date  # update date, if later found
                    self.readlmsg = j["message"]["text"]  # get latest msg

    async def sndmsg(self, msg):
        """integrate cid and message into base url"""
        msg = urllib.parse.quote_plus(msg)
        snd = f"{self.URL}/sendmessage?text={msg}&chat_id={self.CID}"
        try:
            urllib.request.urlopen(snd)  # make request
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError

    async def freq(self):
        """first request for getting chat ids (cids) is done here"""
        try:
            msgreq = urllib.request.urlopen(self.URLR)
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError
        rj = msgreq.read()
        try:
            js = json.loads(rj.decode("utf-8"))
        except json.decoder.JSONDecodeError:
            raise ConnectionError
        cids = []
        """parsing loop through all cids"""
        for n in itertools.count():
            try:
                cid = js["result"][n]["message"]["chat"]["id"]
                if cid not in cids:
                    cids.append(cid)
            except IndexError:
                break
        try:
            self.CID = int(cids[self.NUMBER])  # we pick one cid num-based
        except IndexError:
            await asyncio.sleep(self.TIMEOUT)
            raise ConnectionError

    async def start(self):
        while True:
            try:
                await self.freq() 
                break
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
        while True:
            try:
                await self.readmsg()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start" or self.restart_ch:
                m1 = "Started setting up! "
                m2 = "Type /start when want to restart! "
                m3 = "Please, choose language! (/en, /ru)"
                msg = m1 + m2 + m3
                try:
                    await self.sndmsg(msg)
                    self.pdate = self.ldate
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                if self.restart_ch:
                    self.restart_ch = False  # if restarted - change state
                break
        await self.lmode()

    async def restart(self):
        self.__init__(token, self.NUMBER)
        self.restart_ch = True
        await self.start()

    async def lmode(self):
        while True:
            try:
                await self.readmsg()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start" and self.ldate != self.pdate:
                await self.restart()  # check for restart command, date
            """compare latest msg with offered commands"""
            if self.readlmsg == "/en":
                self.lang = "en"
                try:
                    await self.sndmsg("English is chosen")
                    break
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
            elif self.readlmsg == "/ru":
                self.lang = "ru"
                try:
                    await self.sndmsg("Выбран русский")
                    break
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
        await self.cmode()      

    async def cmode(self):
        """Counting Mode: define operation"""
        while True:
            try:
                await self.readmsg()  # get latest msg
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start":
                await self.restart()  # check for restart command
            if not self.choice_msg:
                if self.lang == "en":
                    m1 = "Do you want a linear algebra operations: "
                    m2 = "matrix-matrix or vector-matrix multiplication; "
                    m3 = "arithmetics operations: multiplication, "
                    m4 = "division, squaring, taking square root? "
                elif self.lang == "ru":
                    m1 = "Вы хотите операции линейной алгебры: "
                    m2 = "матрично-матричное или векторно-матричное умножение; "
                    m3 = "арифметические операциии: умножение, "
                    m4 = "деление, возведение в квадрат, взятие квадратного корня? "
                m5 = "(/mmul, /vmul, /mul, /div, /sqr, /root):"
                msg = m1 + m2 + m3 + m4 + m5
                try:
                    await self.sndmsg(msg)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.choice_msg = True  # change state; not to resend msg
            """compare latest msg with offered commands"""
            if self.readlmsg == "/mul":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndmsg("Выбрано умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "mul"  # send state info and update choice var
                break
            elif self.readlmsg == "/div":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Division is chosen")
                    elif self.lang == "ru":
                        await self.sndmsg("Выбрано деление")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "div"  # send state info and update choice var
                break
            elif self.readlmsg == "/sqr":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Square taking is chosen")
                    elif self.lang == "ru":
                        await self.sndmsg("Выбрано возведение в квадрат")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "sqr"  # send state info and update choice var
                break
            elif self.readlmsg == "/root":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Square root taking is chosen")
                    elif self.lang == "ru":
                        await  self.sndmsg("Выбрано взятие квадратного корня")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "root"  # send state info and update choice var
                break
            elif self.readlmsg == "/vmul":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Vector-matrix multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndmsg("Выбрано векторно-матричное умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "vmul"  # send state info and update choice var
                break
            elif self.readlmsg == "/mmul":
                try:
                    if self.lang == "en":
                        await self.sndmsg("Matrix-matrix multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndmsg("Выбрано матрично-матричное умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "mmul"  # send state info and update choice var
                break
        """record previous msg and go to the next method"""
        self.prevmsg = self.readlmsg
        await self.diff()

    async def diff(self):
        """Difficulty Speed"""
        while True:
            try:
                await self.readmsg()  # read latest msg
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start":
                await self.restart()  # check for restart command
            """send method's msg"""
            if not self.numb_msg:
                if self.lang == "en":
                    m1 = "How many iterations do you want before increasing "
                    m2 = "difficulty? (/d[number]):"
                elif self.lang == "ru":
                    m1 = "Как много итераций прежде чем увеличить сложность? "
                    m2 = "(/d[число])"
                msg = m1 + m2
                try:
                    await self.sndmsg(msg)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.numb_msg = True  # change state; not to resend msg
            """try to extract diff, restart if got msg and failed"""
            try:
                rpass = re.findall(r"^\/d([0-9]{1,6})", self.readlmsg)
                self.rpass = int(rpass[0])  # num is extracted here
            except IndexError:
                if self.readlmsg != self.prevmsg:
                    try:
                        if self.lang == "en":
                            await self.sndmsg(self.ERROR_EN)
                        elif self.lang == "ru":
                            await self.sndmsg(self.ERROR_RU)
                    except ConnectionError:
                        await asyncio.sleep(self.TIMEOUT)
                        continue
                    await self.restart()
                continue
            """send state info"""
            if self.rpass:  # if num exist we send info about mode
                try:
                    if self.lang == "en":
                        msg = f"Have chosen {self.rpass} iterations mode" 
                        await self.sndmsg(msg)
                    elif self.lang == "ru":
                        msg = f"Выбрана {self.rpass} скорость усложнения" 
                        await self.sndmsg(msg)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                break
        """record previous msg and go to the next method"""
        self.prevmsg = self.readlmsg
        await self.chmod()

    async def chmod(self):
        """Diff Init parameters"""
        while True:
            try:
                await self.readmsg()  # read latest msg
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start":
                await self.restart()  # check for restart command
            elif self.readlmsg == "/0":  # check for continue command
                try:
                    if self.lang == "en":
                        await self.sndmsg("No changes to init mode were made!")
                    elif self.lang == "ru":
                        await self.sndmsg("Никаких изменений!")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.ch_cmod = False
                break
            """send method's msg"""
            if self.chm_msg is False:
                if self.lang == "en":
                    m1 = "Do you want to change initial difficulty? If yes "
                    m2 = "- number or numbers, depending on counting mode; "
                    m3 = "if no - type /0"
                elif self.lang == "ru":
                    m1 = "Вы хотите изменить начальную сложность? Если да "
                    m2 = "введите одно число или два в зависимости от мода "
                    m3 = "счета; если не хотите менять - введите /0"
                msg = m1 + m2 + m3 
                try:
                    await self.sndmsg(msg)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chm_msg = True
            """try to extract new parameters, restart if got msg and failed"""
            try:
                if self.readlmsg == self.prevmsg:
                    raise IndexError("Got no new messages!")
                self.chmf = re.findall(r"([0-9]{1,6})", self.readlmsg)
                self.chm1 = int(self.chmf[0])
                if self.chosen != "sqr" and self.chosen != "root":
                    self.chm2 = int(self.chmf[1])
            except IndexError:
                if self.readlmsg != self.prevmsg and self.readlmsg != "/0":
                    try:
                        if self.lang == "en":
                            await self.sndmsg(self.ERROR_EN)
                        elif self.lang == "ru":
                            await self.sndmsg(self.ERROR_RU)
                    except ConnectionError:
                        await asyncio.sleep(self.TIMEOUT)
                        continue
                    await self.restart()
                continue
            """send state info based on counting mode"""
            if self.chosen != "sqr" and self.chosen != "root":
                if self.lang == "en":
                    chm = f"Have chosen [{self.chm1}, {self.chm2}] init mode"
                elif self.lang == "ru":
                    chm = f"Выбран [{self.chm1}, {self.chm2}] стартовый мод"
                try:
                    await self.sndmsg(chm)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                break
            else:
                if self.lang == "en":
                    chm = f"Have chosen {self.chm1} init mode"
                elif self.lang == "ru":
                    chm = f"Выбран {self.chm1} стартовый мод"
                try:
                    await self.sndmsg(chm)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue 
                break
        """record previous msg and go to the next method
        based on counting mode"""
        self.prevmsg = self.readlmsg
        if self.chosen == "vmul" or self.chosen == "mmul":
            await self.size()  # for matrix operations we need their size
        else:
            await self.count()  # for basic operation we start counting now

    async def size(self):
        """Matrix Size"""
        while True:
            try:
                await self.readmsg()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlmsg == "/start":
                self.restart()  # check for restart command
            """send method's msg"""
            if self.msized_msg is False:
                if self.lang == "en":
                    m1 = "How big the matrix should be? "
                    m2 = "2 or 3 or 2/3 (4)? "
                elif self.lang == "ru":
                    m1 = "Каков должен быть размер матрицы "
                    m2 = "2 или 3 или 2/3? "
                m3 = "(/m2, /m3, /m4):"
                msg = m1 + m2 + m3
                try:
                    await self.sndmsg(msg)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.msized_msg = True
            """try to extract msize, restart if got msg and failed"""
            try:  # to extract num from latest msg
                msize = re.findall(r"^\/m([2-4])", self.readlmsg)
                self.msize = int(msize[0])
            except IndexError:
                if self.readlmsg != self.prevmsg:
                    try:
                        if self.lang == "en":
                            await self.sndmsg(self.ERROR_EN)
                        elif self.lang == "ru":
                            await self.sndmsg(self.ERROR_RU)
                    except ConnectionError:
                        await asyncio.sleep(self.TIMEOUT)
                        continue
                    await self.restart()
                break
        await self.count()  # start counting now

    async def count(self):
        """Counting endless loop"""
        for i in itertools.count(start=1, step=1):  # specially defined loop
            if self.chosen == "mul":  # check for counting mode option
                if self.fmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1, n2 = self.chm1, self.chm2
                    else:
                        n1, n2 = self.mnum[0], self.mnum[1]
                    self.fmul = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        n1 += 1  # every 2nd pass increase 1st num
                    elif i % 2 == 0 and i != 1:
                        n2 += 1  # every 1st pass increase 2nd num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        n1 += 1  # every 2nd pass increase 1st num
                    elif i % self.rpass == 1 and i != 1:
                        n2 += 1  # every 1st pass increase 2nd num
                await ml(n1, n2, obj=self)
            elif self.chosen == "div":  # check for counting mode option
                if self.fdiv:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1, n2 = self.chm1, self.chm2
                    else:
                        n1, n2 = self.dnum[0], self.dnum[1]
                    self.fdiv = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                else:  # for other vars we use usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        n1 += 1  # every 1st pass increase 1st num
                await dl(n1, n2, obj=self)
            elif self.chosen == "sqr":  # check for counting mode option
                if self.fsqr:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1 = self.chm1
                    else:
                        n1 = self.sqnum
                    self.fsqr = False
                if self.rpass == 1:  # special case
                    if i != 1:
                        n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.rpass == 1 and i != 1:
                        n1 += 1  # every pass increase num
                await sqr(n1, obj=self)
            elif self.chosen == "root":  # check for counting mode option
                if self.froot:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1 = self.chm1
                    else:
                        n1 = self.ronum
                    self.froot = False
                if self.rpass == 1:  # special case
                    if i != 1:
                        n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.rpass == 1 and i != 1:
                        n1 += 1  # every pass increase num
                await root(n1, obj=self)
            elif self.chosen == "vmul":  # check for counting mode option
                if self.fvmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1, n2 = self.chm1, self.chm2
                    else:
                        n1, n2 = self.vmnum[0], self.vmnum[1]
                    self.fvmul = False  # change state not to reconvert vars
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        n1 += 1  # every 1st pass increase 1st num
                else:  # usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        n1 += 1  # every 1st pass increase 1st num
                await vml(n1, n2, matrix=self.msize, obj=self)
            elif self.chosen == "mmul":  # check for counting mode option
                if self.fmmul:  # define loop's from initial obj's vars
                    if self.ch_cmod:
                        n1, n2 = self.chm1, self.chm2
                    else:
                        n1, n2 = self.mmnum[0], self.mmnum[1]
                    self.fmmul = False
                if self.rpass == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        n2 += 1  # every 1st pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        n1 += 1  # every 2nd pass increase 1st num
                else:  # usual approach
                    if i % (self.rpass * 2) == 1 and i != 1:
                        n2 += 1  # every 1st pass increase 2nd num
                    elif i % self.rpass == 1 and i != 1:
                        n1 += 1  # every 2nd pass increase 1st num
                await mml(n1, n2, matrix=self.msize, obj=self)


pbot0 = Bot(token, 0)
pbot1 = Bot(token, 1)
pbot2 = Bot(token, 2)
pbot3 = Bot(token, 3)
pbot4 = Bot(token, 4)
pbot5 = Bot(token, 5)
pbot6 = Bot(token, 6)
pbot7 = Bot(token, 7)
pbot8 = Bot(token, 8)
pbot9 = Bot(token, 9)
pbot10 = Bot(token, 10)
pbot11 = Bot(token, 11)
pbot12 = Bot(token, 12)
pbot13 = Bot(token, 13)
pbot14 = Bot(token, 14)
pbot15 = Bot(token, 15)
pbot16 = Bot(token, 16)
pbot17 = Bot(token, 17)
pbot18 = Bot(token, 18)
pbot19 = Bot(token, 19)
pbot20 = Bot(token, 20)
pbot21 = Bot(token, 21)
pbot22 = Bot(token, 22)
pbot23 = Bot(token, 23)
pbot24 = Bot(token, 24)
pbot25 = Bot(token, 25)
pbot26 = Bot(token, 26)
pbot27 = Bot(token, 27)
pbot28 = Bot(token, 28)
pbot29 = Bot(token, 29)
pbot30 = Bot(token, 30)
pbot31 = Bot(token, 31)
pbot32 = Bot(token, 32)
pbot33 = Bot(token, 33)
pbot34 = Bot(token, 34)
pbot35 = Bot(token, 35)
pbot36 = Bot(token, 36)
pbot37 = Bot(token, 37)
pbot38 = Bot(token, 38)
pbot39 = Bot(token, 39)
pbot40 = Bot(token, 40)
pbot41 = Bot(token, 41)
pbot42 = Bot(token, 42)
pbot43 = Bot(token, 43)
pbot44 = Bot(token, 44)
pbot45 = Bot(token, 45)
pbot46 = Bot(token, 46)
pbot47 = Bot(token, 47)
pbot48 = Bot(token, 48)
pbot49 = Bot(token, 49)


async def main():
    await asyncio.gather(
        pbot0.start(),
        pbot1.start(),
        pbot2.start(),
        pbot3.start(),
        pbot4.start(),
        pbot5.start(),
        pbot6.start(),
        pbot7.start(),
        pbot8.start(),
        pbot9.start(),
        pbot10.start(),
        pbot11.start(),
        pbot12.start(),
        pbot13.start(),
        pbot14.start(),
        pbot15.start(),
        pbot16.start(),
        pbot17.start(),
        pbot18.start(),
        pbot19.start(),
        pbot20.start(),
        pbot21.start(),
        pbot22.start(),
        pbot23.start(),
        pbot24.start(),
        pbot24.start(),
        pbot25.start(),
        pbot26.start(),
        pbot27.start(),
        pbot28.start(),
        pbot29.start(),
        pbot30.start(),
        pbot31.start(),
        pbot32.start(),
        pbot33.start(),
        pbot34.start(),
        pbot35.start(),
        pbot36.start(),
        pbot37.start(),
        pbot38.start(),
        pbot39.start(),
        pbot40.start(),
        pbot41.start(),
        pbot42.start(),
        pbot43.start(),
        pbot44.start(),
        pbot45.start(),
        pbot46.start(),
        pbot47.start(),
        pbot48.start(),
        pbot49.start()
        )


asyncio.run(main())
