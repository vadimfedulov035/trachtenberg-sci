#!/usr/bin/env python3
import re
import random
import asyncio
import numpy as np


if __name__ == "__main__":
    print("This is not a standalone program!")


async def ml(multiplicand, multiplier, obj=None):
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
    if a in [0, 1, 2] or b in [0, 1, 2]:  # if got 0, 1, 2 to multiply - skip
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
                await obj.sndmsg(obj.MISTYPE)
                obj.prevmsg = obj.readlmsg
                continue
        if uc == obj.uc:
            continue  # if got old msg try again
        obj.uc = uc  # record user answer
        """compare user answers against right ones"""
        if uc == c:
            try:
                await obj.sndmsg("You're God Damn right!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                await obj.sndmsg(f"No, right answer is {c}!")
            except ConnectionError:
                continue
            break


async def dl(dividend, divider, obj=None):
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
                await obj.sndmsg(obj.MISTYPE)
                obj.prevmsg = obj.readlmsg
                continue
        if uc1 == obj.uc1 and uc2 == obj.uc2:
            continue  # if got old msg try again
        obj.uc1, obj.uc2 = uc1, uc2  # record user answers
        """compare user answers against right ones"""
        if uc1 == c1 and uc2 == c2:
            try:
                await obj.sndmsg("You're God Damn right!")
            except ConnectionError:
                continue
            break
        else:
            msg1 = f"No, right answer is {c1} "
            msg2 = f"with residual of {c2}!"
            msg = msg1 + msg2
            try:
                await obj.sndmsg(msg)
            except ConnectionError:
                continue
            break


async def sqr(sqrn, obj=None):
    """Arithmetics operation: Squaring"""
    x1, y1 = 1, 1
    for i in range(sqrn - 1):
        x1 *= 10
    for i in range(sqrn):
        y1 *= 10
    y1 -= 1
    a = random.randint(x1, y1)
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
                    await obj.sndmsg(obj.MISTYPE)
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
                await obj.sndmsg("You're God Damn right!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                await obj.sndmsg(f"No, right answer is {c}!")
            except ConnectionError:
                continue
            break


async def root(root, obj=None):
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
        await sqr(root, obj=obj)
    obj.c = c
    try:
        await obj.sndmsg(f"{b} ** 0.5 = ?")
    except ConnectionError:
        await root(root, obj=None)
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
                    await obj.sndmsg(obj.MISTYPE)
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
                await obj.sndmsg("You're God Damn right!")
            except ConnectionError:
                continue
            break
        elif uc != c:
            try:
                await obj.sndmsg(f"No, right answer is {int(c)}!")
            except ConnectionError:
                continue
            break


async def vml(multiplicand, multiplier, matrix=2, obj=None):
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
        a = np.matrix([[a1, b1],
                       [a2, b2]])
        b = np.matrix([[l1],
                       [l2]])
    elif matrix == 3:  # here we need to specify more vars
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        a3 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        l3 = random.randint(x2, y2)
        a = np.matrix([[a1, b1, c1],
                       [a2, b2, c2],
                       [a3, b3, c3]])
        b = np.matrix([[l1],
                       [l2],
                       [l3]])
    elif matrix == 2.5:  # here we specify more vars depending on choice
        choices = ["2x3", "3x2"]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
        if matrix == 2.5 and fch == "2x3":
            c1 = random.randint(x1, y1)
            c2 = random.randint(x1, y1)
            l3 = random.randint(x2, y2)
            a = np.matrix([[a1, b1, c1],
                           [a2, b2, c2]])
            b = np.matrix([[l1],
                           [l2],
                           [l3]])
        elif matrix == 2.5 and fch == "3x2":
            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)
            a = np.matrix([[a1, b1],
                           [a2, b2],
                           [a3, b3]])
            b = np.matrix([[l1],
                           [l2]])
    c = np.matmul(a, b)
    """COUNTING BLOCK"""
    if matrix == 2 or matrix == 2.5 and fch == "2x3":
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
                    await obj.sndmsg(obj.MISTYPE)
                    obj.prevmsg = obj.readlmsg
                    continue
            if uc1 == obj.uc1 and uc2 == obj.uc2:
                continue  # if got old msg try again
            obj.uc1, obj.uc2 = uc1, uc2  # if got new msg work with nums
            """compare user answers against right ones"""
            if uc1 == c1 and uc2 == c2:
                try:
                    await obj.sndmsg("You're God Damn right!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    await obj.sndmsg(f"No, right answer is\n{c}!")
                except ConnectionError:
                    continue
                break
    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
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
                        await obj.sndmsg(obj.MISTYPE)
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
                    await obj.sndmsg("You're God Damn right!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    await obj.sndmsg("No, right answer is\n{c}!")
                except ConnectionError:
                    continue
                break


async def mml(multiplicand, multiplier, matrix=2, obj=None):
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
        a = np.matrix([[a1, b1],
                       [a2, b2]])
        b = np.matrix([[l1, q1],
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
        a = np.matrix([[a1, b1, c1],
                       [a2, b2, c2],
                       [a3, b3, c3]])
        b = np.matrix([[l1, q1, s1],
                       [l2, q2, s2],
                       [l3, q3, s3]])
    elif matrix == 2.5:  # here we specify more vars depending on choice
        choices = ["2x3", "3x2"]
        fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
        if matrix == 2.5 and fch == "2x3":
            c1 = random.randint(x2, y2)
            c2 = random.randint(x2, y2)
            l3 = random.randint(x2, y2)
            q3 = random.randint(x2, y2)
            a = np.matrix([[a1, b1, c1],
                           [a2, b2, c2]])
            b = np.matrix([[l1, q1],
                           [l2, q2],
                           [l3, q3]])
        elif matrix == 2.5 and fch == "3x2":
            a3 = random.randint(x1, y1)
            b3 = random.randint(x1, y1)
            s1 = random.randint(x2, y2)
            s2 = random.randint(x2, y2)
            a = np.matrix([[a1, b1],
                           [a2, b2],
                           [a3, b3]])
            b = np.matrix([[l1, q1, s1],
                           [l2, q2, s2]])
    c = np.matmul(a, b)
    """COUNTING BLOCK"""
    if matrix == 2 or matrix == 2.5 and fch == "2x3":
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
                        await obj.sndmsg(obj.MISTYPE)
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
                    await obj.sndmsg("You're God Damn right!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    await obj.sndmsg(f"No, right answer is\n{c}")
                except ConnectionError:
                    continue
                break
    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
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
                        await obj.sndmsg(obj.MISTYPE)
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
                    await obj.sndmsg("You're God Damn right!")
                except ConnectionError:
                    continue
                break
            else:
                try:
                    await obj.sndmsg(f"No, right answer is\n{c}")
                except ConnectionError:
                    continue
                break
