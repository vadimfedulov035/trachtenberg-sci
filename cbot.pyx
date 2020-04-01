import re
import random
import json
import itertools
import urllib.request
import urllib.parse
import urllib.error
import asyncio
import numpy as np


with open("token.conf", "r") as config:
    token = config.read().rstrip()

class GetOut(Exception):
    pass


async def ml(multiplicand, multiplier, o):
    """Arithmetics operation: Multiplication"""
    cdef int x1, x2, y1, y2, a, b, c
    cdef int u
    x1, x2, y1, y2 = 1, 1, 1, 1
    for i in range(multiplicand - 1):
        x1 *= 10
    for i in range(multiplicand):
        y1 *= 10
    for i in range(multiplier - 1):
        x2 *= 10
    for i in range(multiplier):
        y2 *= 10
    if x2 == 1:
        x2 = 3
    y1 -= 1
    y2 -= 1
    try:
        while True:
            a = random.randint(x1, y1)
            b = random.randint(x2, y2)
            c = a * b
            if c == o.c:  # if got the same answer restart
                continue
            o.c = c  # record answer
            try:
                await o.sndm(f"{a} * {b} = ?")
            except ConnectionError:
                continue
            o.prevm = o.readlm
            while True:
                try:
                    await o.readm()
                except ConnectionError:
                    continue
                if o.readlm == "/start":  # check for restart m
                    await o.restart()
                elif o.readlm == o.prevm:  # check for novelty
                    continue
                else:
                    try:  # to extract num from latest m
                        o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                        u = int(o.rf[0])
                    except IndexError:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                        o.prevm = o.readlm
                        continue
                if u == o.u:
                    continue  # if got old m try again
                o.u = u  # record user answer
                """compare user answers against right ones"""
                if u == c:
                    try:
                        if o.lang == "en":
                            await o.sndm("You're God Damn right!")
                        elif o.lang == "ru":
                            await o.sndm("Вы чертовски правы!")
                    except ConnectionError:
                        continue
                    raise GetOut
                elif u != c:
                    try:
                        if o.lang == "en":
                            await o.sndm(f"No, right answer is {c}!")
                        elif o.lang == "ru":
                            await o.sndm(f"Нет, правильный ответ {c}!")
                    except ConnectionError:
                        continue
                    raise GetOut
    except GetOut:
        pass


async def dl(dividend, divider, o):
    """Arithmetics operation: Division"""
    cdef int x1, x2, y1, y2, a, b, c1, c2
    x1, x2, y1, y2 = 1, 1, 1, 1
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
    try:
        while True:
            a = random.randint(x1, y1)
            b = random.randint(x2, y2)
            c1 = a // b
            c2 = a % b
            if c1 == o.c1 or c2 == o.c2:  # if got the same answer restart
                continue
            o.c1, o.c2 = c1, c2  # record answers
            await o.sndm(f"{a} // | % {b} = ?")
            o.prevm = o.readlm
            while True:
                try:
                    await o.readm()
                except ConnectionError:
                    continue
                if o.readlm == "/start":  # check for restart m
                    await o.restart()
                elif o.readlm == o.prevm:  # check for novelty
                    continue
                else:
                    try:  # to extract nums from latest m
                        o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                        u1, u2 = int(o.rf[0]), int(o.rf[1])
                    except IndexError:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                        o.prevm = o.readlm
                        continue
                if u1 == o.u1 and u2 == o.u2:
                    continue  # if got old m try again
                o.u1, o.u2 = u1, u2  # record user answers
                """compare user answers against right ones"""
                if u1 == c1 and u2 == c2:
                    try:
                        if o.lang == "en":
                            await o.sndm("You're God Damn right!")
                        elif o.lang == "ru":
                            await o.sndm("Вы чертовски правы!")
                    except ConnectionError:
                        continue
                    raise GetOut
                else:
                    if o.lang == "en":
                        m1 = f"No, right answer is {c1} "
                        m2 = f"with residual of {c2}!"
                    elif o.lang == "ru":
                        m1 = f"Нет, правильный ответ это {c1} "
                        m2 = f"с остатком {c2}!"
                    m = m1 + m2
                    try:
                        await o.sndm(m)
                    except ConnectionError:
                        continue
                    raise GetOut
    except GetOut:
        pass


async def sqr(sqrn, o):
    """Arithmetics operation: Squaring"""
    cdef int x1, y1, a, c
    x1, y1 = 1, 1
    for i in range(sqrn - 1):
        x1 *= 10
    for i in range(sqrn):
        y1 *= 10
    y1 -= 1
    try:
        while True:
            a = random.randint(x1, y1)
            c = a ** 2
            if c == o.c:
                continue
            o.c = c
            try:
                await o.sndm(f"{a} ** 2 = ?")
            except ConnectionError:
                continue
            o.prevm = o.readlm
            while True:
                await asyncio.sleep(o.TIMEOUT)
                try:
                    await o.readm()
                except ConnectionError:
                    continue
                if o.readlm == "/start":  # check for restart m
                    await o.restart()
                elif o.readlm == o.prevm:  # check for novelty
                    continue
                else:
                    try:  # to extract num from latest m
                        o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                        u = int(o.rf[0])
                    except IndexError:
                        try:
                            if o.lang == "en":
                                await o.sndm(o.MISTYPE_EN)
                            elif o.lang == "ru":
                                await o.sndm(o.MISTYPE_RU)
                        except ConnectionError:
                            continue
                        o.prevm = o.readlm
                        continue
                if u == o.u:
                    continue  # if got old m try again
                o.u = u  # record user answer
                """compare user answers against right ones"""
                if u == c:
                    try:
                        if o.lang == "en":
                            await o.sndm("You're God Damn right!")
                        elif o.lang == "ru":
                            await o.sndm("Вы чертовски правы!")
                    except ConnectionError:
                        continue
                    raise GetOut
                elif u != c:
                    try:
                        if o.lang == "en":
                            await o.sndm(f"No, right answer is {c}!")
                        elif o.lang == "ru":
                            await o.sndm(f"Нет, правильный ответ {c}!")
                    except ConnectionError:
                        continue
                    raise GetOut
    except GetOut:
        pass


async def root(rootn, o):
    """Arithmetics operation: Square Root taking"""
    cdef int x1, y1, a, b, c
    x1, y1 = 1, 1
    for i in range(rootn - 1):
        x1 *= 10
    for i in range(rootn):
        y1 *= 10
    y1 -= 1
    try:
        while True:
            a = random.randint(x1, y1)
            b = a ** 2
            c = int(np.sqrt(b))
            if c == o.c:
                continue
            o.c = c
            try:
                await o.sndm(f"{b} ** 0.5 = ?")
            except ConnectionError:
                continue
            o.prevm = o.readlm
            while True:
                await asyncio.sleep(o.TIMEOUT)
                await o.readm()
                if o.readlm == "/start":  # check for restart m
                    await o.restart()
                elif o.readlm == o.prevm:  # check for novelty
                    continue
                else:
                    try:  # to extract nums from latest m
                        o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                        u = int(o.rf[0])
                    except IndexError:
                        try:
                            if o.lang == "en":
                                await o.sndm(o.MISTYPE_EN)
                            elif o.lang == "ru":
                                await o.sndm(o.MISTYPE_RU)
                        except ConnectionError:
                            continue
                        o.prevm = o.readlm
                        continue
                if u == o.u:
                    continue  # if got old m try again
                o.u = u  # record user answer
                """compare user answers against right ones"""
                if u == c:
                    try:
                        if o.lang == "en":
                            await o.sndm("You're God Damn right!")
                        elif o.lang == "ru":
                            await o.sndm("Вы чертовски правы!")
                    except ConnectionError:
                        continue
                    raise GetOut
                elif u != c:
                    try:
                        if o.lang == "en":
                            await o.sndm(f"No, right answer is {int(c)}!")
                        elif o.lang == "ru":
                            await o.sndm(f"Нет, правильный ответ {int(c)}!")
                    except ConnectionError:
                        continue
                    raise GetOut
    except GetOut:
        pass


async def vml(multiplicand, multiplier, mx, o):
    """Linear Algebra operation: vector-matrix multiplication"""
    cdef int a1, a2, a3, b1, b2, b3, c1, c2, c3
    cdef int l1, l2, l3
    x1, x2, y1, y2 = 1, 1, 1, 1
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
    try:
        while True:
            """SPECIFICATION BLOCK"""
            """non-static vars for basic matricies specification"""
            a1 = random.randint(x1, y1)
            a2 = random.randint(x1, y1)
            b1 = random.randint(x1, y1)
            b2 = random.randint(x1, y1)
            l1 = random.randint(x2, y2)
            l2 = random.randint(x2, y2)
            if mx == 2:  # here we don't need to specify more vars
                a = np.array([[a1, b1],
                              [a2, b2]])
                b = np.array([[l1],
                              [l2]])
            elif mx == 3:  # here we need to specify more vars
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
            elif mx == 4:  # here we specify more vars depending on choice
                choices = ["2x3", "3x2"]
                fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
                if fch == "2x3":
                    c1 = random.randint(x1, y1)
                    c2 = random.randint(x1, y1)
                    l3 = random.randint(x2, y2)
                    a = np.array([[a1, b1, c1],
                                  [a2, b2, c2]])
                    b = np.array([[l1],
                                  [l2],
                                  [l3]])
                elif fch == "3x2":
                    a3 = random.randint(x1, y1)
                    b3 = random.randint(x1, y1)
                    a = np.array([[a1, b1],
                                  [a2, b2],
                                  [a3, b3]])
                    b = np.array([[l1],
                                  [l2]])
            c = np.matmul(a, b)
            """COUNTING BLOCK"""
            if mx == 2 or mx == 4 and fch == "2x3":
                c1, c2 = c[0], c[1]
                if c1 == o.c1 or c2 == o.c2:
                    continue
                o.c1, o.c2 = c1, c2
                try:
                    await o.sndm(f"{a}\n*****\n{b}\n=====\n?????")
                except ConnectionError:
                    continue
                o.prevm = o.readlm
                while True:
                    try:
                        await o.readm()
                    except ConnectionError:
                        continue
                    if o.readlm == "/start":  # check for restart m
                        await o.restart()
                    elif o.readlm == o.prevm:  # check for novelty
                        continue
                    else:
                        try:  # to extract nums from latest m
                            o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                            u1, u2 = int(o.rf[0]), int(o.rf[1])
                        except IndexError:
                            if o.lang == "en":
                                await o.sndm(o.MISTYPE_EN)
                            elif o.lang == "ru":
                                await o.sndm(o.MISTYPE_RU)
                            o.prevm = o.readlm
                            continue
                    if u1 == o.u1 and u2 == o.u2:
                        continue  # if got old m try again
                    o.u1, o.u2 = u1, u2  # if got new m work with nums
                    """compare user answers against right ones"""
                    if u1 == c1 and u2 == c2:
                        try:
                            if o.lang == "en":
                                await o.sndm("You're God Damn right!")
                            elif o.lang == "ru":
                                await o.sndm("Вы чертовски правы!")
                        except ConnectionError:
                            continue
                        break
                    else:
                        try:
                            if o.lang == "en":
                                await o.sndm(f"No, right answer is\n{c}!")
                            elif o.lang == "ru":
                                await o.sndm(f"Нет, правильный ответ\n{c}!")
                        except ConnectionError:
                            continue
                        break
            elif mx == 3 or mx == 4 and fch == "3x2":
                c1, c2, c3 = c[0], c[1], c[2]
                if c1 == o.c1 or c2 == o.c2 or c3 == o.c3:
                    continue
                o.c1, o.c2, o.c3 = c1, c2, c3  # record answers
                try:
                    await o.sndm(f"{a}\n*****\n{b}\n=====\n?????")
                except ConnectionError:
                    continue
                o.c1, o.c2 = c1, c2
                o.prevm = o.readlm
                while True:
                    await asyncio.sleep(o.TIMEOUT)
                    try:
                        await o.readm()
                    except ConnectionError:
                        continue
                    if o.readlm == "/start":  # check for restart m
                        await o.restart()
                    elif o.readlm == o.prevm:  # check for novelty
                        continue
                    else:
                        try:  # to extract nums from latest m
                            o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                            u1, u2, u3 = int(o.rf[0]), int(o.rf[1]), int(o.rf[2])
                        except IndexError:
                            try:
                                if o.lang == "en":
                                    await o.sndm(o.MISTYPE_EN)
                                elif o.lang == "ru":
                                    await o.sndm(o.MISTYPE_RU)
                            except ConnectionError:
                                continue
                            o.prevm = o.readlm
                            continue
                    if u1 == o.u1 and u2 == o.u2 and u3 == o.u3:
                        continue  # if got old m try again
                    o.u1, o.u2, o.u3 = u1, u2, u3  # record user answer
                    """compare user answers against right ones"""
                    if u1 == c1 and u2 == c2 and u3 == c3:
                        try:
                            if o.lang == "en":
                                await o.sndm("You're God Damn right!")
                            elif o.lang == "ru":
                                await o.sndm("Вы чертовски правы!")
                        except ConnectionError:
                            continue
                        raise GetOut
                    else:
                        try:
                            if o.lang == "en":
                                await o.sndm(f"No, right answer is\n{c}!")
                            elif o.lang == "ru":
                                await o.sndm(f"Нет, правильный ответ\n{c}!")
                        except ConnectionError:
                            continue
                        raise GetOut
    except GetOut:
        pass


async def mml(multiplicand, multiplier, mx, o):
    """Linear Algebra operation: matrix-matrix multiplication"""
    cdef int x1, x2, y1, y2
    cdef int a1, a2, a3, b1, b2, b3, c1, c2, c3
    cdef int l1, l2, l3, q1, q2, q3, s1, s2, s3
    x1, x2, y1, y2 = 1, 1, 1, 1
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
    try:
        while True:
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
            if mx == 2:  # here we don't need to specify more vars
                a = np.array([[a1, b1],
                              [a2, b2]])
                b = np.array([[l1, q1],
                              [l2, q2]])
            elif mx == 3:  # here we need to specify more vars
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
            elif mx == 4:  # here we specify more vars depending on choice
                choices = ["2x3", "3x2"]
                fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
                if fch == "2x3":
                    c1 = random.randint(x2, y2)
                    c2 = random.randint(x2, y2)
                    l3 = random.randint(x2, y2)
                    q3 = random.randint(x2, y2)
                    a = np.array([[a1, b1, c1],
                                  [a2, b2, c2]])
                    b = np.array([[l1, q1],
                                  [l2, q2],
                                  [l3, q3]])
                elif fch == "3x2":
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
            if mx == 2 or mx == 4 and fch == "2x3":
                c1, c2, c3, c4 = c[0, 0], c[0, 1], c[1, 0], c[1, 1]
                if c1 == o.c1 or c2 == o.c2:
                    continue
                elif c3 == o.c3 or c4 == o.c4:
                    continue
                o.c1, o.c2 = c1, c2
                o.c3, o.c4 = c3, c4
                try:
                    await o.sndm(f"{a}\n*****\n{b}\n=====\n?????")
                except ConnectionError:
                    continue
                o.prevm = o.readlm
                while True:
                    await asyncio.sleep(o.TIMEOUT)
                    try:
                        await o.readm()
                    except ConnectionError:
                        continue
                    if o.readlm == "/start":  # check for restart m
                        await o.restart()
                    elif o.readlm == o.prevm:  # check for novelty
                        continue
                    else:
                        try:  # to extract nums from latest m
                            o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                            u1, u2 = int(o.rf[0]), int(o.rf[1])
                            u3, u4 = int(o.rf[2]), int(o.rf[3])
                        except IndexError:
                            try:
                                if o.lang == "en":
                                    await o.sndm(o.MISTYPE_EN)
                                elif o.lang == "ru":
                                    await o.sndm(o.MISTYPE_RU)
                            except ConnectionError:
                                continue
                            o.prevm = o.readlm
                            continue
                    if u1 == o.u1 and u2 == o.u2:
                        continue  # if got old m try again
                    elif u3 == o.u3 and u4 == o.u4:
                        continue  # if got old m try again
                    o.u1, o.u2 = u1, u2  # record user answers
                    o.u3, o.u4 = u3, u4  # record user answers
                    """compare user answers against right ones"""
                    if u1 == c1 and u2 == c2 and u3 == c3 and u4 == c4:
                        try:
                            if o.lang == "en":
                                await o.sndm("You're God Damn right!")
                            elif o.lang == "ru":
                                await o.sndm("Вы чертовски правы!")
                        except ConnectionError:
                            continue
                        break
                    else:
                        try:
                            if o.lang == "en":
                                await o.sndm(f"No, right answer is\n{c}!")
                            elif o.lang == "ru":
                                await o.sndm(f"Нет, правильный ответ\n{c}!")
                        except ConnectionError:
                            continue
                        break
            elif mx == 3 or mx == 4 and fch == "3x2":
                c1, c2, c3 = c[0, 0], c[0, 1], c[0, 2]
                c4, c5, c6 = c[1, 0], c[1, 1], c[1, 2]
                c7, c8, c9 = c[2, 1], c[2, 1], c[2, 2]
                if c1 == o.c1 or c2 == o.c2 or c3 == o.c3:
                    continue
                elif c4 == o.c4 or c5 == o.c5 or c6 == o.c6:
                    continue
                o.c1, o.c2, o.c3 = c1, c2, c3  # record answers
                o.c4, o.c5, o.c6 = c4, c5, c6  # record answers
                o.c7, o.c8, o.c9 = c7, c8, c9  # record answers
                await o.sndm(f"{a}\n*****\n{b}\n=====\n?????")
                o.prevm = o.readlm
                while True:
                    await asyncio.sleep(o.TIMEOUT)
                    try:
                        await o.readm()
                    except ConnectionError:
                        continue
                    if o.readlm == "/start":  # check for restart m
                        await o.restart()
                    elif o.readlm == o.prevm:  # check for novelty
                        continue
                    else:
                        try:  # to extract nums from latest m
                            o.rf = re.findall(r"([0-9]{1,10})", o.readlm)
                            u1, u2, u3 = int(o.rf[0]), int(o.rf[1]), int(o.rf[2])
                            u4, u5, u6 = int(o.rf[3]), int(o.rf[4]), int(o.rf[5])
                            u7, u8, u9 = int(o.rf[6]), int(o.rf[7]), int(o.rf[8])
                        except IndexError:
                            try:
                                if o.lang == "en":
                                    await o.sndm(o.MISTYPE_EN)
                                elif o.lang == "ru":
                                    await o.sndm(o.MISTYPE_RU)
                            except ConnectionError:
                                continue
                            o.prevm = o.readlm
                            continue
                    if u1 == o.u1 and u2 == o.u2 and u3 == o.u3:
                        continue  # if got old m try again
                    elif u4 == o.u4 and u5 == o.u5 and u6 == o.u6:
                        continue  # if got old m try again
                    elif u7 == o.u7 and u8 == o.u8 and u9 == o.u9:
                        continue  # if got old m try again
                    o.u1, o.u2, o.u3 = u1, u2, u3  # record user answers
                    o.u4, o.u5, o.u5 = u4, u5, u6  # record user answers
                    o.u7, o.u8, o.u9 = u7, u8, u9  # record user answers
                    """compare user answers against right ones"""
                    if u1 == c1 and u2 == c2 and u3 == c3:
                        try:
                            if o.lang == "en":
                                await o.sndm("You're God Damn right!")
                            elif o.lang == "ru":
                                await o.sndm("Вы чертовски правы!")
                        except ConnectionError:
                            continue
                        raise GetOut
                    else:
                        try:
                            if o.lang == "en":
                                await o.sndm(f"No, right answer is\n{c}!")
                            elif o.lang == "ru":
                                await o.sndm(f"Нет, правильный ответ\n{c}!")
                        except ConnectionError:
                            continue
                        raise GetOut
    except GetOut:
        pass


cdef class Bot():
    """define main variables"""
    cdef public str TOKEN
    cdef public int NUMBER
    cdef public str CID
    cdef public double TIMEOUT
    """define message urls and message variables"""
    cdef public str URL, URLR, ERROR_EN, ERROR_RU, MISTYPE_EN, MISTYPE_RU
    """define right answers and user-supplied ones"""
    cdef public int c, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cdef public int u, u1, u2, u3, u4, u5, u6, u7, u8, u9
    """define all messages sent without an error"""
    cdef public str m, m1, m2, m3, m4, m5
    cdef public str prevm, readlm
    """define all boolean variables of first message sender"""
    cdef public int sm, tm, fm, om, diffch  # (s)econd(m)essage..(o)ptional(m)
    cdef public int resch, fmul, fdiv, fsqr, froot, fvmul, fmmul # (f)ormat
    cdef public int date, pdate, ldate
    cdef public list rf, mnum, dnum, vmnum, mmnum
    cdef public int sqnum, ronum
    cdef public str lang, chosen
    cdef public int n1, n2
    cdef public int ms
    cdef public int diffs

    def __init__(self, tok, num):
        """static variables are defined here for correct start up"""
        self.TOKEN = tok  # token for connection to API
        self.NUMBER = num  # num serves as enumerator of cid later
        self.TIMEOUT = 0.0001  # serves as placeholder for switching
        self.URL = f"https://api.telegram.org/bot{self.TOKEN}"
        self.URLR = self.URL + "/getupdates"
        self.ERROR_EN = "Sorry, I don't understand you, I will restart dialog!"
        self.ERROR_RU = "Извините, я не понимаю вас, я начну диалог с начала!"
        self.MISTYPE_EN = "Sorry, I didn't understand you, type more clearly!"
        self.MISTYPE_RU = "Извините, я не понимаю вас, печатайте чётче!"
        """non-static variables are defined here for further work"""
        self.date = 0  # date set to zero will serve in expression as starter
        self.prevm = "None"
        self.c, self.u = 0, 0
        self.c1, self.c2, self.c3 = 0, 0, 0
        self.c4, self.c5, self.c6 = 0, 0, 0
        self.c7, self.c8, self.c9 = 0, 0, 0
        self.u1, self.u2, self.u3 = 0, 0, 0
        self.u4, self.u5, self.u6 = 0, 0, 0
        self.u7, self.u8, self.u9 = 0, 0, 0
        self.mnum = [2, 1]
        self.dnum = [4, 2]
        self.vmnum = [1, 1]
        self.mmnum = [1, 1]
        self.sqnum = 2
        self.ronum = 2
        self.tm = False
        self.fm = False
        self.om = False
        self.diffch = True
        self.resch = False
        self.fmul = True
        self.fdiv = True
        self.fvmul = True
        self.fmmul = True
        self.fsqr = True
        self.froot = True

    async def readm(self):
        await asyncio.sleep(self.TIMEOUT)
        """new reqest to get fresh json data"""
        try:
            mreq = urllib.request.urlopen(self.URLR)
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError
        rj = mreq.read()
        try:
            js = json.loads(rj.decode("utf-8"))
        except json.decoder.JSONDecodeError:
            raise ConnectionError
        """set offset for bulk deletion of old messages"""
        if len(js["result"]) == 100:
            upd_id = js["result"][99]["update_id"]
            try:
                urllib.request.urlopen(f"{self.URLR}?offset={upd_id}")
            except (urllib.error.URLError, urllib.error.HTTPError):
                raise ConnectionError
        """loop through json to find last message by date"""
        for j in js["result"]:
            cid = j["message"]["chat"]["id"]
            if str(cid) == self.CID:  # check date only if CID in m matches
                date = j["message"]["date"]
                if date >= self.date:
                    self.ldate = date  # update date, if later found
                    self.readlm = j["message"]["text"]  # get latest m

    async def sndm(self, m):
        """integrate cid and message into base url"""
        m = urllib.parse.quote_plus(m)
        snd = f"{self.URL}/sendmessage?text={m}&chat_id={self.CID}"
        try:
            urllib.request.urlopen(snd)  # make request
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError

    async def readf(self):
        while True:
            with open("cids.log", "r") as f:
                cids = f.read().rstrip().split("\n")
                try:
                    self.CID = cids[self.NUMBER]
                    break
                except IndexError:
                   await asyncio.sleep(self.TIMEOUT) 
                   continue

    async def error(self):
        try:
            if self.lang == "en":
                await self.sndm(self.ERROR_EN)
            elif self.lang == "ru":
                await self.sndm(self.ERROR_RU)
        except ConnectionError:
            await asyncio.sleep(self.TIMEOUT)

    async def start(self):
        while True:
            try:
                await self.readf()
                break
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
        while True:
            try:
                await self.readm()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start" or self.resch:
                self.m1 = "Started setting up! "
                self.m2 = "Type /start when want to restart! "
                self.m3 = "Please, choose language! (/en, /ru)"
                self.m = self.m1 + self.m2 + self.m3
                try:
                    await self.sndm(self.m)
                    self.pdate = self.ldate
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                if self.resch:
                    self.resch = False  # if restarted - change state
                break
        await self.lmode()

    async def restart(self):
        self.__init__(token, self.NUMBER)
        self.resch = True
        await self.start()

    async def lmode(self):
        while True:
            try:
                await self.readm()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start" and self.ldate != self.pdate:
                await self.restart()  # check for restart command, date
            """compare latest m with offered commands"""
            if self.readlm == "/en":
                self.lang = "en"
                try:
                    await self.sndm("English is chosen")
                    break
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
            elif self.readlm == "/ru":
                self.lang = "ru"
                try:
                    await self.sndm("Выбран русский")
                    break
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
        await self.cmode()

    async def cmode(self):
        """Counting Mode: define operation"""
        while True:
            try:
                await self.readm()  # get latest m
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start":
                await self.restart()  # check for restart command
            if not self.sm:
                if self.lang == "en":
                    self.m1 = "Do you want a linear algebra operations: "
                    self.m2 = "matrix-matrix or vector-matrix multiplication; "
                    self.m3 = "arithmetics operations: multiplication, "
                    self.m4 = "division, squaring, taking square root? "
                elif self.lang == "ru":
                    self.m1 = "Вы хотите операции линейной алгебры: "
                    self.m2 = "матрично-матричное или векторно-матричное умножение; "
                    self.m3 = "арифметические операциии: умножение, "
                    self.m4 = "деление, возведение в квадрат, взятие квадратного корня? "
                self.m5 = "(/mmul, /vmul, /mul, /div, /sqr, /root):"
                self.m = self.m1 + self.m2 + self.m3 + self.m4 + self.m5
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.sm = True  # change state; not to resend m
            """compare latest m with offered commands"""
            if self.readlm == "/mul":
                try:
                    if self.lang == "en":
                        await self.sndm("Multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "mul"  # send state info and update choice var
                break
            elif self.readlm == "/div":
                try:
                    if self.lang == "en":
                        await self.sndm("Division is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано деление")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "div"  # send state info and update choice var
                break
            elif self.readlm == "/sqr":
                try:
                    if self.lang == "en":
                        await self.sndm("Square taking is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано возведение в квадрат")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "sqr"  # send state info and update choice var
                break
            elif self.readlm == "/root":
                try:
                    if self.lang == "en":
                        await self.sndm("Square root taking is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано взятие квадратного корня")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "root"  # send state info and update choice var
                break
            elif self.readlm == "/vmul":
                try:
                    if self.lang == "en":
                        await self.sndm("Vector-matrix multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано векторно-матричное умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "vmul"  # send state info and update choice var
                break
            elif self.readlm == "/mmul":
                try:
                    if self.lang == "en":
                        await self.sndm("Matrix-matrix multiplication is chosen")
                    elif self.lang == "ru":
                        await self.sndm("Выбрано матрично-матричное умножение")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.chosen = "mmul"  # send state info and update choice var
                break
        """record previous m and go to the next method"""
        self.prevm = self.readlm
        await self.diff()

    async def diff(self):
        """Difficulty Speed"""
        while True:
            try:
                await self.readm()  # read latest m
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start":
                await self.restart()  # check for restart command
            """send method's m"""
            if not self.tm:
                if self.lang == "en":
                    self.m1 = "How many iterations do you want before increasing "
                    self.m2 = "difficulty? (/d1, /d3, /d5, /d10, /d15):"
                elif self.lang == "ru":
                    self.m1 = "Как много итераций прежде чем увеличить сложность? "
                    self.m2 = "(/d1, /d3, /d5, /d10, /d15):"
                self.m = self.m1 + self.m2
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.tm = True  # change state; not to resend m
            """try to extract diff, restart if got m and failed"""
            try:
                self.rf = re.findall(r"^\/d([0-9]{1,6})", self.readlm)
                self.diffs = int(self.rf[0])  # num is extracted here
                if self.diffs not in (1, 3, 5, 10, 15):
                    await self.error()
                    await self.restart()
            except IndexError:
                if self.readlm != self.prevm:
                    await self.error()
                    await self.restart()
                continue
            """send state info"""
            if self.diffs:  # if num exist we send info about mode
                try:
                    if self.lang == "en":
                        self.m = f"Have chosen {self.diffs} iterations mode"
                        await self.sndm(self.m)
                    elif self.lang == "ru":
                        self.m = f"Выбрана {self.diffs} скорость усложнения"
                        await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                break
        """record previous m and go to the next method"""
        self.prevm = self.readlm
        await self.chmod()

    async def chmod(self):
        """Diff Init parameters"""
        while True:
            try:
                await self.readm()  # read latest m
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start":
                await self.restart()  # check for restart command
            elif self.readlm == "/0":  # check for continue command
                try:
                    if self.lang == "en":
                        await self.sndm("No changes to init mode were made!")
                    elif self.lang == "ru":
                        await self.sndm("Никаких изменений!")
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.diffch = False
                break
            """send method's m"""
            if self.fm is False:
                if self.lang == "en":
                    self.m1 = "Do you want to change initial difficulty? If yes "
                    self.m2 = "- number or numbers, depending on counting mode; "
                    self.m3 = "if no - type /0"
                elif self.lang == "ru":
                    self.m1 = "Вы хотите изменить начальную сложность? Если да "
                    self.m2 = "введите одно число или два в зависимости от мода "
                    self.m3 = "счета; если не хотите менять - введите /0"
                self.m = self.m1 + self.m2 + self.m3
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.fm = True
            """try to extract new parameters, restart if got m and failed"""
            try:
                if self.readlm == self.prevm:
                    raise IndexError("Got no new messages!")
                self.self.rf = re.findall(r"([0-9]{1,6})", self.readlm)
                self.chm1 = int(self.self.rf[0])
                if self.chosen != "sqr" and self.chosen != "root":
                    self.chm2 = int(self.chm[1])
            except IndexError:
                if self.readlm != self.prevm and self.readlm != "/0":
                    await self.error()
                    await self.restart()
                continue
            """send state info based on counting mode"""
            if self.chosen != "sqr" and self.chosen != "root":
                if self.lang == "en":
                    self.m = f"Have chosen [{self.chm1}, {self.chm2}] init mode"
                elif self.lang == "ru":
                    self.m = f"Выбран [{self.chm1}, {self.chm2}] стартовый мод"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                break
            else:
                if self.lang == "en":
                    self.m = f"Have chosen {self.chm1} init mode"
                elif self.lang == "ru":
                    self.m = f"Выбран {self.chm1} стартовый мод"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                break
        """record previous m and go to the next method
        based on counting mode"""
        self.prevm = self.readlm
        if self.chosen == "vmul" or self.chosen == "mmul":
            await self.msize()  # for mx operations we need their size
        else:
            await self.count()  # for basic operation we start counting now

    async def msize(self):
        """Matrix Size"""
        while True:
            try:
                await self.readm()
            except ConnectionError:
                await asyncio.sleep(self.TIMEOUT)
                continue
            if self.readlm == "/start":
                self.restart()  # check for restart command
            """send method's m"""
            if not self.om:
                if self.lang == "en":
                    self.m1 = "How big the matrix should be? "
                    self.m2 = "2 or 3 or 2/3 (4)? "
                elif self.lang == "ru":
                    self.m1 = "Каков должен быть размер матрицы "
                    self.m2 = "2 или 3 или 2/3? "
                self.m3 = "(/m2, /m3, /m4):"
                self.m = self.m1 + self.m2 + self.m3
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    await asyncio.sleep(self.TIMEOUT)
                    continue
                self.om = True
            """try to extract msize, restart if got m and failed"""
            try:  # to extract num from latest m
                if self.readlm == self.prevm:
                    raise IndexError("Got no new messages!")
                self.rf = re.findall(r"^\/m([2-4])", self.readlm)
                self.ms = int(self.rf[0])
                try:
                    if self.lang == "en":
                        if self.ms == 4:
                            self.m = "Matrix size 2/3 is chosen"
                        else:
                            self.m = f"Matrix size {self.ms} is chosen"
                    elif self.lang == "ru":
                        if self.ms == 4:
                            self.m = "Размер матрицы 2/3 выбран"
                        else:
                            self.m = f"Размер матрицы {self.ms} выбран"
                    await self.sndm(self.m)
                except ConnectionError:
                    await self.error()
                    await self.restart()
            except IndexError:
                if self.readlm != self.prevm and self.readlm != "/0":
                    await self.error()
                    await self.restart()
                continue
            break
        await self.count()  # start counting now

    async def count(self):
        """Counting endless loop"""
        for i in itertools.count(start=1, step=1):  # specially defined loop
            if self.chosen == "mul":  # check for counting mode option
                if self.fmul:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1, self.n2 = self.chm1, self.chm2
                    else:
                        self.n1, self.n2 = self.mnum[0], self.mnum[1]
                    self.fmul = False
                if self.diffs == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % 2 == 0 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                else:  # for other vars we use usual approach
                    if i % (self.diffs * 2) == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % self.diffs == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                await ml(self.n1, self.n2, self)
            elif self.chosen == "div":  # check for counting mode option
                if self.fdiv:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1, self.n2 = self.chm1, self.chm2
                    else:
                        self.n1, self.n2 = self.dnum[0], self.dnum[1]
                    self.fdiv = False
                if self.diffs == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                else:  # for other vars we use usual approach
                    if i % (self.diffs * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.diffs == 1 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                await dl(self.n1, self.n2, self)
            elif self.chosen == "sqr":  # check for counting mode option
                if self.fsqr:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1 = self.chm1
                    else:
                        self.n1 = self.sqnum
                    self.fsqr = False
                if self.diffs == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.diffs == 1 and i != 1:
                        self.n1 += 1  # every pass increase num
                await sqr(self.n1, o=self)
            elif self.chosen == "root":  # check for counting mode option
                if self.froot:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1 = self.chm1
                    else:
                        self.n1 = self.ronum
                    self.froot = False
                if self.diffs == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.diffs == 1 and i != 1:
                        self.n1 += 1  # every pass increase num
                await root(self.n1, self)
            elif self.chosen == "vmul":  # check for counting mode option
                if self.fvmul:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1, self.n2 = self.chm1, self.chm2
                    else:
                        self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                    self.fvmul = False  # change state not to reconvert vars
                if self.diffs == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                else:  # usual approach
                    if i % (self.diffs * 2) == 1 and i != 1:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.diffs == 1 and i != 1:
                        self.n1 += 1  # every 1st pass increase 1st num
                await vml(self.n1, self.n2, self.ms, self)
            elif self.chosen == "mmul":  # check for counting mode option
                if self.fmmul:  # define loop's from initial o's vars
                    if self.diffch:
                        self.n1, self.n2 = self.chm1, self.chm2
                    else:
                        self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                    self.fmmul = False
                if self.diffs == 1:  # special case
                    if i % 2 == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                    elif i % 2 == 0 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                else:  # usual approach
                    if i % (self.diffs * 2) == 1 and i != 1:
                        self.n2 += 1  # every 1st pass increase 2nd num
                    elif i % self.diffs == 1 and i != 1:
                        self.n1 += 1  # every 2nd pass increase 1st num
                await mml(self.n1, self.n2, self.ms, self)


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
pbot20 = Bot(token, 10)
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
