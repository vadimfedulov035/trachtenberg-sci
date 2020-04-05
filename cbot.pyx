import re
import json
import pickle
import itertools
import urllib.request
import urllib.parse
import urllib.error
import asyncio
import numpy as np


with open("tok.conf", "r") as f:
    token = f.read().rstrip()  # read config for token info


async def ml(object o):
    """Arithmetics operation: Multiplication"""
    cdef int x1, x2, y1, y2, a, b, c, u
    x1, x2, y1, y2 = 1, 1, 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    for i in range(o.n2 - 1):
        x2 *= 10
    for i in range(o.n2):
        y2 *= 10
    if x2 == 1:
        x2 = 3
    y1 -= 1
    y2 -= 1
    while True:
        a = np.random.randint(x1, y1)
        b = np.random.randint(x2, y2)
        c = a * b
        if c == o.c:  # if got the same answer restart
            continue
        o.c = c  # record answer
        o.m = f"{a} * {b} = ?"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        try:
            await o.rdm()
        except ConnectionError:
            continue
        if o.rdlm == "/start":  # check for restart command
            await o.restart()
        elif o.rdlm == o.prevm:  # check for novelty
            continue
        else:
            try:  # try to extract number from latest message
                o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                u = int(o.r[0])
            except IndexError:
                try:
                    if o.lang == "en":
                        await o.sndm(o.MISTYPE_EN)
                    elif o.lang == "ru":
                        await o.sndm(o.MISTYPE_RU)
                except ConnectionError:
                    continue
                o.prevm = o.rdlm  # record latest message for check
                continue
        if u == o.u:
            continue  # if got old message restart loop
        o.u = u  # record user answer
        """compare user answer against right one"""
        if u == c:
            if o.lang == "en":
                o.m = "You're God Damn right!"
            elif o.lang == "ru":
                o.m = "Вы чертовски правы!"
        else:
            if o.lang == "en":
                o.m = f"No, right answer is {c}!"
            elif o.lang == "ru":
                o.m = f"Нет, правильный ответ {c}!"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        break


async def dl(object o):
    """Arithmetics operation: Division"""
    cdef int x1, x2, y1, y2, a, b, c1, c2, u
    x1, x2, y1, y2 = 1, 1, 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    for i in range(o.n2 - 1):
        x2 *= 10
    for i in range(o.n2):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    while True:
        a = np.random.randint(x1, y1)
        b = np.random.randint(x2, y2)
        c1 = a // b
        c2 = a % b
        if c1 == o.c1 or c2 == o.c2:  # if got the same answer restart
            continue
        o.c1, o.c2 = c1, c2  # record answers
        o.m = f"{a} // | % {b} = ?"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        try:
            await o.rdm()
        except ConnectionError:
            continue
        if o.rdlm == "/start":  # check for restart command
            await o.restart()
        elif o.rdlm == o.prevm:  # check for novelty
            continue
        else:
            try:  # try to extract numbers from latest message
                o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                u1, u2 = int(o.r[0]), int(o.r[1])
            except IndexError:
                try:
                    if o.lang == "en":
                        await o.sndm(o.MISTYPE_EN)
                    elif o.lang == "ru":
                        await o.sndm(o.MISTYPE_RU)
                except ConnectionError:
                    continue
                o.prevm = o.rdlm  # record latest message for check
                continue
        if u1 == o.u1 and u2 == o.u2:
            continue  # if got old message restart loop
        o.u1, o.u2 = u1, u2  # record user answers
        """compare user answer against right one"""
        if u1 == c1 and u2 == c2:
            if o.lang == "en":
                o.m = "You're God Damn right!"
            elif o.lang == "ru":
                o.m = "Вы чертовски правы!"
        else:
            if o.lang == "en":
                o.m1 = f"No, right answer is {c1} "
                o.m2 = f"with residual of {c2}!"
            elif o.lang == "ru":
                o.m1 = f"Нет, правильный ответ это {c1} "
                o.m2 = f"с остатком {c2}!"
            o.m = o.m1 + o.m2
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        break


async def sqr(object o):
    """Arithmetics operation: Squaring"""
    cdef int x1, y1, a, c, u
    x1, y1 = 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    y1 -= 1
    while True:
        a = np.random.randint(x1, y1)
        c = a ** 2
        if c == o.c:
            continue
        o.c = c
        o.m = f"{a} ** 2 = ?"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        try:
            await o.rdm()
        except ConnectionError:
            continue
        if o.rdlm == "/start":  # check for restart command
            await o.restart()
        elif o.rdlm == o.prevm:  # check for novelty
            continue
        else:
            try:  # try to extract number from latest message
                o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                u = int(o.r[0])
            except IndexError:
                try:
                    if o.lang == "en":
                        await o.sndm(o.MISTYPE_EN)
                    elif o.lang == "ru":
                        await o.sndm(o.MISTYPE_RU)
                except ConnectionError:
                    continue
                o.prevm = o.rdlm  # record latest message for check
                continue
        if u == o.u:
            continue  # if got old message restart loop
        o.u = u  # record user answer
        """compare user answer against right one"""
        if u == c:
            if o.lang == "en":
                o.m = "You're God Damn right!"
            elif o.lang == "ru":
                o.m = "Вы чертовски правы!"
        else:
            if o.lang == "en":
                o.m = f"No, right answer is {c}!"
            elif o.lang == "ru":
                o.m = f"Нет, правильный ответ {c}!"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        break


async def root(object o):
    """Arithmetics operation: Square Root taking"""
    cdef int x1, y1, a, b, c, u
    x1, y1 = 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    y1 -= 1
    while True:
        a = np.random.randint(x1, y1)
        b = a ** 2
        c = int(np.sqrt(b))
        if c == o.c:
            continue
        o.c = c
        o.m = f"{b} ** 0.5 = ?"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        try:
            await o.rdm()
        except ConnectionError:
            continue
        if o.rdlm == "/start":  # check for restart m
            await o.restart()
        elif o.rdlm == o.prevm:  # check for novelty
            continue
        else:
            try:  # try to extract numbers from latest message
                o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                u = int(o.r[0])
            except IndexError:
                try:
                    if o.lang == "en":
                        await o.sndm(o.MISTYPE_EN)
                    elif o.lang == "ru":
                        await o.sndm(o.MISTYPE_RU)
                except ConnectionError:
                    continue
                o.prevm = o.rdlm  # record latest message for check
                continue
        if u == o.u:
            continue  # if got old message restart loop
        o.u = u  # record user answer
        """compare user answer against right one"""
        if u == c:
            if o.lang == "en":
                o.m = "You're God Damn right!"
            elif o.lang == "ru":
                o.m = "Вы чертовски правы!"
        else:
            if o.lang == "en":
                o.m = f"No, right answer is {int(c)}!"
            elif o.lang == "ru":
                o.m = f"Нет, правильный ответ {int(c)}!"
        try:
            await o.sndm(o.m)
        except ConnectionError:
            continue
        break


async def vml(object o):
    """Linear Algebra operation: vector-matrix multiplication"""
    cdef int a1, a2, a3, b1, b2, b3, c1, c2, c3, l1, l2, l3, u
    cdef list choices
    cdef str fch
    x1, x2, y1, y2 = 1, 1, 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    for i in range(o.n2 - 1):
        x2 *= 10
    for i in range(o.n2):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    while True:
        """SPECIFICATION BLOCK"""
        """non-static vars for basic matricies specification"""
        a1 = np.random.randint(x1, y1)
        a2 = np.random.randint(x1, y1)
        b1 = np.random.randint(x1, y1)
        b2 = np.random.randint(x1, y1)
        l1 = np.random.randint(x2, y2)
        l2 = np.random.randint(x2, y2)
        if o.ms == 2:  # here we don't need to specify more vars
            a = np.array([[a1, b1],
                          [a2, b2]])
            b = np.array([[l1],
                          [l2]])
        elif o.ms == 3:  # here we need to specify more vars
            c1 = np.random.randint(x1, y1)
            c2 = np.random.randint(x1, y1)
            a3 = np.random.randint(x1, y1)
            b3 = np.random.randint(x1, y1)
            c3 = np.random.randint(x1, y1)
            l3 = np.random.randint(x2, y2)
            a = np.array([[a1, b1, c1],
                          [a2, b2, c2],
                          [a3, b3, c3]])
            b = np.array([[l1],
                          [l2],
                          [l3]])
        elif o.ms == 4:  # here we specify more vars depending on choice
            choices = ["2x3", "3x2"]
            fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
            if fch == "2x3":
                c1 = np.random.randint(x1, y1)
                c2 = np.random.randint(x1, y1)
                l3 = np.random.randint(x2, y2)
                a = np.array([[a1, b1, c1],
                              [a2, b2, c2]])
                b = np.array([[l1],
                              [l2],
                              [l3]])
            elif fch == "3x2":
                a3 = np.random.randint(x1, y1)
                b3 = np.random.randint(x1, y1)
                a = np.array([[a1, b1],
                              [a2, b2],
                              [a3, b3]])
                b = np.array([[l1],
                              [l2]])
        c = np.matmul(a, b)
        """COUNTING BLOCK"""
        if o.ms == 2 or o.ms == 4 and fch == "2x3":
            c1, c2 = c[0], c[1]
            if c1 == o.c1 or c2 == o.c2:
                continue
            o.c1, o.c2 = c1, c2
            o.m = f"{a}\n*****\n{b}\n=====\n?????"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
            o.prevm = o.rdlm  # record latest message for check
        elif o.ms == 3 or o.ms == 4 and fch == "3x2":
            c1, c2, c3 = c[0], c[1], c[2]
            if c1 == o.c1 or c2 == o.c2 or c3 == o.c3:
                continue
            o.c1, o.c2, o.c3 = c1, c2, c3  # record answers
            o.m = f"{a}\n*****\n{b}\n=====\n?????"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
            o.c1, o.c2 = c1, c2
            o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        if o.ms == 2 or o.ms == 4 and fch == "2x3":
            try:
                await o.rdm()
            except ConnectionError:
                continue
            if o.rdlm == "/start":  # check for restart m
                await o.restart()
            elif o.rdlm == o.prevm:  # check for novelty
                continue
            else:
                try:  # try to extract nums from latest m
                    o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                    u1, u2 = int(o.r[0]), int(o.r[1])
                except IndexError:
                    try:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    o.prevm = o.rdlm  # record latest message for check
                    continue
            if u1 == o.u1 and u2 == o.u2:
                continue  # if got old message restart loop
            o.u1, o.u2 = u1, u2  # record user answer
            """compare user answer against right one"""
            if u1 == c1 and u2 == c2:
                if o.lang == "en":
                    o.m = "You're God Damn right!"
                elif o.lang == "ru":
                    o.m = "Вы чертовски правы!"
            else:
                if o.lang == "en":
                    o.m = f"No, right answer is\n{c}!"
                elif o.lang == "ru":
                    o.m = f"Нет, правильный ответ\n{c}!"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
        elif o.ms == 3 or o.ms == 4 and fch == "3x2":
            try:
                await o.rdm()
            except ConnectionError:
                continue
            if o.rdlm == "/start":  # check for restart m
                await o.restart()
            elif o.rdlm == o.prevm:  # check for novelty
                continue
            else:
                try:  # try to extract nums from latest m
                    o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                    u1, u2, u3 = int(o.r[0]), int(o.r[1]), int(o.r[2])
                except IndexError:
                    try:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    o.prevm = o.rdlm  # record latest message for check
                    continue
            if u1 == o.u1 and u2 == o.u2 and u3 == o.u3:
                continue  # if got old message restart loop
            o.u1, o.u2, o.u3 = u1, u2, u3  # record user answer
            """compare user answer against right one"""
            if u1 == c1 and u2 == c2 and u3 == c3:
                if o.lang == "en":
                    o.m = "You're God Damn right!"
                elif o.lang == "ru":
                    o.m = "Вы чертовски правы!"
            else:
                if o.lang == "en":
                    o.m = f"No, right answer is\n{c}!"
                elif o.lang == "ru":
                    o.m = f"Нет, правильный ответ\n{c}!"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
        break


async def mml(object o):
    """Linear Algebra operation: matrix-matrix multiplication"""
    cdef int x1, x2, y1, y2, u
    cdef int a1, a2, a3, b1, b2, b3, c1, c2, c3
    cdef int l1, l2, l3, q1, q2, q3, s1, s2, s3
    cdef list choices
    cdef str fch
    x1, x2, y1, y2 = 1, 1, 1, 1
    for i in range(o.n1 - 1):
        x1 *= 10
    for i in range(o.n1):
        y1 *= 10
    for i in range(o.n2 - 1):
        x2 *= 10
    for i in range(o.n2):
        y2 *= 10
    y1 -= 1
    y2 -= 1
    while True:
        """SPECIFICATION BLOCK"""
        """non-static vars for basic matricies specification"""
        a1 = np.random.randint(x1, y1)
        a2 = np.random.randint(x1, y1)
        b1 = np.random.randint(x1, y1)
        b2 = np.random.randint(x1, y1)
        l1 = np.random.randint(x2, y2)
        l2 = np.random.randint(x2, y2)
        q1 = np.random.randint(x2, y2)
        q2 = np.random.randint(x2, y2)
        if o.ms == 2:  # here we don't need to specify more vars
            a = np.array([[a1, b1],
                          [a2, b2]])
            b = np.array([[l1, q1],
                          [l2, q2]])
        elif o.ms == 3:  # here we need to specify more vars
            c1 = np.random.randint(x1, y1)
            c2 = np.random.randint(x1, y1)
            s1 = np.random.randint(x2, y2)
            s2 = np.random.randint(x2, y2)
            a3 = np.random.randint(x1, y1)
            b3 = np.random.randint(x1, y1)
            c3 = np.random.randint(x1, y1)
            l3 = np.random.randint(x2, y2)
            q3 = np.random.randint(x2, y2)
            s3 = np.random.randint(x2, y2)
            a = np.array([[a1, b1, c1],
                          [a2, b2, c2],
                          [a3, b3, c3]])
            b = np.array([[l1, q1, s1],
                          [l2, q2, s2],
                          [l3, q3, s3]])
        elif o.ms == 4:  # here we specify more vars depending on choice
            choices = ["2x3", "3x2"]
            fch = np.random.choice(choices, 1, replace=True, p=[0.5, 0.5])
            if fch == "2x3":
                c1 = np.random.randint(x2, y2)
                c2 = np.random.randint(x2, y2)
                l3 = np.random.randint(x2, y2)
                q3 = np.random.randint(x2, y2)
                a = np.array([[a1, b1, c1],
                              [a2, b2, c2]])
                b = np.array([[l1, q1],
                              [l2, q2],
                              [l3, q3]])
            elif fch == "3x2":
                a3 = np.random.randint(x1, y1)
                b3 = np.random.randint(x1, y1)
                s1 = np.random.randint(x2, y2)
                s2 = np.random.randint(x2, y2)
                a = np.array([[a1, b1],
                              [a2, b2],
                              [a3, b3]])
                b = np.array([[l1, q1, s1],
                              [l2, q2, s2]])
        c = np.matmul(a, b)
        """COUNTING BLOCK"""
        if o.ms == 2 or o.ms == 4 and fch == "2x3":
            c1, c2, c3, c4 = c[0, 0], c[0, 1], c[1, 0], c[1, 1]
            if c1 == o.c1 or c2 == o.c2:
                continue
            elif c3 == o.c3 or c4 == o.c4:
                continue
            o.c1, o.c2 = c1, c2
            o.c3, o.c4 = c3, c4
            o.m = f"{a}\n*****\n{b}\n=====\n?????"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
            o.prevm = o.rdlm  # record latest message for check
        elif o.ms == 3 or o.ms == 4 and fch == "3x2":
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
            o.m = f"{a}\n*****\n{b}\n=====\n?????"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
            o.prevm = o.rdlm  # record latest message for check
        break
    while True:
        if o.ms == 2 or o.ms == 4 and fch == "2x3":
            try:
                await o.rdm()
            except ConnectionError:
                continue
            if o.rdlm == "/start":  # check for restart m
                await o.restart()
            elif o.rdlm == o.prevm:  # check for novelty
                continue
            else:
                try:  # try to extract nums from latest m
                    o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                    u1, u2 = int(o.r[0]), int(o.r[1])
                    u3, u4 = int(o.r[2]), int(o.r[3])
                except IndexError:
                    try:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    o.prevm = o.rdlm  # record latest message for check
                    continue
            if u1 == o.u1 and u2 == o.u2:
                continue  # if got old message restart loop
            elif u3 == o.u3 and u4 == o.u4:
                continue  # if got old message restart loop
            o.u1, o.u2 = u1, u2  # record user answer
            o.u3, o.u4 = u3, u4  # record user answer
            """compare user answer against right one"""
            if u1 == c1 and u2 == c2 and u3 == c3 and u4 == c4:
                if o.lang == "en":
                    o.m = "You're God Damn right!"
                elif o.lang == "ru":
                    o.m = "Вы чертовски правы!"
            else:
                if o.lang == "en":
                    o.m = f"No, right answer is\n{c}!"
                elif o.lang == "ru":
                    o.m = f"Нет, правильный ответ\n{c}!"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
        elif o.ms == 3 or o.ms == 4 and fch == "3x2":
            try:
                await o.rdm()
            except ConnectionError:
                continue
            if o.rdlm == "/start":  # check for restart m
                await o.restart()
            elif o.rdlm == o.prevm:  # check for novelty
                continue
            else:
                try:  # try to extract numbers from latest message
                    o.r = re.findall(r"([0-9]{1,10})", o.rdlm)
                    u1, u2, u3 = int(o.r[0]), int(o.r[1]), int(o.r[2])
                    u4, u5, u6 = int(o.r[3]), int(o.r[4]), int(o.r[5])
                    u7, u8, u9 = int(o.r[6]), int(o.r[7]), int(o.r[8])
                except IndexError:
                    try:
                        if o.lang == "en":
                            await o.sndm(o.MISTYPE_EN)
                        elif o.lang == "ru":
                            await o.sndm(o.MISTYPE_RU)
                    except ConnectionError:
                        continue
                    o.prevm = o.rdlm  # record latest message for check
                    continue
            if u1 == o.u1 and u2 == o.u2 and u3 == o.u3:
                continue  # if got old message restart loop
            elif u4 == o.u4 and u5 == o.u5 and u6 == o.u6:
                continue  # if got old message restart loop
            elif u7 == o.u7 and u8 == o.u8 and u9 == o.u9:
                continue  # if got old message restart loop
            o.u1, o.u2, o.u3 = u1, u2, u3  # record user answer
            o.u4, o.u5, o.u5 = u4, u5, u6  # record user answer
            o.u7, o.u8, o.u9 = u7, u8, u9  # record user answer
            """compare user answer against right one"""
            if u1 == c1 and u2 == c2 and u3 == c3:
                if o.lang == "en":
                    o.m = "You're God Damn right!"
                elif o.lang == "ru":
                    o.m = "Вы чертовски правы!"
            else:
                if o.lang == "en":
                    o.m = f"No, right answer is\n{c}!"
                elif o.lang == "ru":
                    o.m = f"Нет, правильный ответ\n{c}!"
            try:
                await o.sndm(o.m)
            except ConnectionError:
                continue
        break


cdef class Bot():
    """define main variables"""
    cdef public str TOKEN
    cdef public int NUMBER
    cdef public str CID
    cdef public list ucids
    cdef public double TIMEOUT
    """define message urls and message variables"""
    cdef public str URL, URLR, ERROR_EN, ERROR_RU, MISTYPE_EN, MISTYPE_RU
    """define right answers and user-supplied ones"""
    cdef public int c, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cdef public int u, u1, u2, u3, u4, u5, u6, u7, u8, u9
    """define all messages and message related variables"""
    cdef public str m, m1, m2, m3, m4, m5, prevm, rdlm
    cdef public int mc2, mc3, mc4, mc5, diffch
    """define all mode and mode of count related variables"""
    cdef public list r, mnum, dnum, vmnum, mmnum
    cdef public int sqnum, ronum
    cdef public int st, n1, n2
    """define restart variable and convertion ones for different modes"""
    cdef public int resch, cmul, cdiv, csqr, croot, cvmul, cmmul
    """define all time related variables"""
    cdef public int date, ldate, pdate
    """define all choice related variables"""
    cdef public str lang, mode
    cdef public int s, d, ms

    def __init__(object self, str tok, int num):
        """static variables are defined here for correct start up"""
        self.TOKEN = tok  # try token for connection to API
        self.NUMBER = num  # num serves as enumerator of cid later
        self.TIMEOUT = 0.001  # serves as placeholder for switching
        self.URL = f"https://api.telegram.org/bot{self.TOKEN}"
        self.URLR = self.URL + "/getupdates"
        self.ERROR_EN = "Sorry, I don't understand you, I will restart dialog!"
        self.ERROR_RU = "Извините, я не понимаю вас, я начну диалог с начала!"
        self.MISTYPE_EN = "Sorry, I didn't understand you, type more clearly!"
        self.MISTYPE_RU = "Извините, я не понимаю вас, печатайте чётче!"
        """non-static variables are defined here for further work"""
        self.date = 0  # date set to zero will serve in expression as start var
        self.prevm = "None"  # set to such value because of Cython specifics
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
        self.mc2 = False
        self.mc3 = False
        self.mc4 = False
        self.mc5 = False
        self.diffch = True
        self.resch = False
        self.cmul = True
        self.cdiv = True
        self.cvmul = True
        self.cmmul = True
        self.csqr = True
        self.croot = True
        self.s = 0
        self.d = 0

    async def rdc(self):
        while True:
            """first request for getting chat ids (cids) is done here"""
            try:
                msgreq = urllib.request.urlopen(self.URLR)
            except (urllib.error.URLError, urllib.error.HTTPError):
                continue
            rj = msgreq.read()
            try:
                js = json.loads(rj.decode("utf-8"))
            except json.decoder.JSONDecodeError:
                continue
            try:
                with open("ucids.p", "rb") as f:
                    self.ucids = pickle.load(f)
            except EOFError:
                self.ucids = []
            """parsing loop through all cids"""
            for n in itertools.count():
                try:
                    cid = js["result"][n]["message"]["chat"]["id"]
                    if cid not in self.ucids:
                        self.ucids.append(cid)
                except IndexError:
                    break
            try:
                self.CID = str(self.ucids[self.NUMBER])  # we pick one cid num-based
                break
            except IndexError:
                await asyncio.sleep(self.TIMEOUT)
                continue
        with open("ucids.p", "wb") as f:
            pickle.dump(self.ucids, f, protocol=pickle.HIGHEST_PROTOCOL)

    async def rdm(object self):
        """new reqest to get fresh json data"""
        try:
            mreq = urllib.request.urlopen(self.URLR)
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError  # define ConnectionError as combination
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
            if str(cid) == self.CID:  # check date only if CID in message match
                date = j["message"]["date"]
                if date >= self.date:
                    self.ldate = date  # update date, if later found
                    self.rdlm = j["message"]["text"]  # get latest message

    async def sndm(object self, str m):
        """integrate cid and message into base url"""
        m = urllib.parse.quote_plus(m)
        snd = f"{self.URL}/sendmessage?text={m}&chat_id={self.CID}"
        try:
            urllib.request.urlopen(snd)  # make request
        except (urllib.error.URLError, urllib.error.HTTPError):
            raise ConnectionError  # define ConnectionError as combination

    async def error(object self):
        while True:
            try:
                if self.lang == "en":
                    await self.sndm(self.ERROR_EN)
                elif self.lang == "ru":
                    await self.sndm(self.ERROR_RU)
                break
            except ConnectionError:
                continue

    async def restart(object self):
        self.__init__(token, self.NUMBER)
        self.resch = True
        await self.start()

    async def start(object self):
        await self.rdc()  # get CID
        while True:
            try:
                await self.rdm()  # get latest message
            except ConnectionError:
                continue
            if self.rdlm == "/start" and self.pdate != self.ldate or self.resch:
                self.pdate = self.ldate
                self.m1 = "Started setting up! Type /start at any moment if "
                self.m2 = "you want to restart! Bot restarts everyday at "
                self.m3 = "21:00 MSK, be careful not to lose calculations! "
                self.m4 = "Please, choose language! (/en, /ru)"
                self.m = self.m1 + self.m2 + self.m3 + self.m4
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                if self.resch:
                    self.resch = False  # if restarted - change state
            if self.rdlm == "/en":
                self.m = "English is chosen"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.lang = "en"
                break
            elif self.rdlm == "/ru":
                self.m = "Выбран русский"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.lang = "ru"
                break
        await self.cmode()

    async def cmode(object self):
        """Counting Mode: define operation"""
        while True:
            try:
                await self.rdm()  # read latest message
            except ConnectionError:
                continue
            if self.rdlm == "/start":
                await self.restart()  # check for restart command
            if not self.mc2:
                if self.lang == "en":
                    self.m1 = "Do you want a linear algebra operations: "
                    self.m2 = "matrix, vector-matrix multiplication; "
                    self.m3 = "arithmetics operations: multiplication, "
                    self.m4 = "division, squaring, taking square root?"
                elif self.lang == "ru":
                    self.m1 = "Вы хотите операции линейной алгебры: "
                    self.m2 = "матричное, векторно-матричное умножение; "
                    self.m3 = "арифметические операциии: умножение, деление, "
                    self.m4 = "возведение в квадрат, взятие квадратного корня?"
                self.m5 = " (/mmul, /vmul, /mul, /div, /sqr, /root)"
                self.m = self.m1 + self.m2 + self.m3 + self.m4 + self.m5
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mc2 = True  # change state; not to resend message
            """compare latest message with offered commands"""
            if self.rdlm == "/mul":
                if self.lang == "en":
                    self.m = "Multiplication is chosen"
                elif self.lang == "ru":
                    self.m = "Выбрано умножение"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "mul"  # send state info and update choice var
                break
            elif self.rdlm == "/div":
                if self.lang == "en":
                    self.m = "Division is chosen!"
                elif self.lang == "ru":
                    self.m = "Выбрано деление"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "div"  # send state info and update choice var
                break
            elif self.rdlm == "/sqr":
                if self.lang == "en":
                    self.m = "Square taking is chosen"
                elif self.lang == "ru":
                    self.m = "Выбрано возведение в квадрат"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "sqr"  # send state info and update choice var
                break
            elif self.rdlm == "/root":
                if self.lang == "en":
                    self.m = "Square root taking is chosen"
                elif self.lang == "ru":
                    self.m = "Выбрано взятие квадратного корня"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "root"  # send state info and update choice var
                break
            elif self.rdlm == "/vmul":
                if self.lang == "en":
                    self.m = "Vector-matrix multiplication is chosen"
                elif self.lang == "ru":
                    self.m = "Выбрано векторно-матричное умножение"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "vmul"  # send state info and update choice var
                break
            elif self.rdlm == "/mmul":
                if self.lang == "en":
                    self.m = "Matrix multiplication is chosen"
                elif self.lang == "ru":
                    self.m = "Выбрано матричное умножение"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mode = "mmul"  # send state info and update choice var
                break
        """record previous m and go to the next method"""
        self.prevm = self.rdlm
        await self.diff()

    async def diff(object self):
        """Difficulty Speed"""
        while True:
            try:
                await self.rdm()  # read latest message
            except ConnectionError:
                continue
            if self.rdlm == "/start":
                await self.restart()  # check for restart command
            if not self.mc3:
                if self.lang == "en":
                    self.m1 = "How many iterations do you want before "
                    self.m2 = "increasing difficulty? (/s1, /s3, /s5, "
                    self.m3 = "/s10, /s15, /s25, /s[number])"
                elif self.lang == "ru":
                    self.m1 = "Как много итераций прежде чем "
                    self.m2 = "увеличить сложность? (/s1, /s3, /s5, "
                    self.m3 = "/s10, /s15, /s25, /s[число])"
                self.m = self.m1 + self.m2 + self.m3
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mc3 = True  # change state; not to resend message
            try:
                self.r = re.findall(r"^\/s([0-9]{1,6})", self.rdlm)
                self.s = int(self.r[0])  # num is extracted here
            except IndexError:
                if self.rdlm != self.prevm:
                    await self.error()
                    await self.restart()
                continue
            if self.s:  # if num exist we send info about mode
                if self.lang == "en":
                    self.m = f"Have mode {self.s} iterations mode"
                elif self.lang == "ru":
                    self.m = f"Выбрана {self.s} скорость усложнения"
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                break
        self.prevm = self.rdlm
        await self.chmod()

    async def chmod(object self):
        """Diff Init parameters"""
        while True:
            try:
                await self.rdm()  # read latest message
            except ConnectionError:
                continue
            if self.rdlm == "/start":
                await self.restart()  # check for restart command
            elif self.rdlm == "/0":
                try:  # check for continue command
                    if self.lang == "en":
                        await self.sndm("No changes to init mode were made!")
                    elif self.lang == "ru":
                        await self.sndm("Никаких изменений!")
                except ConnectionError:
                    continue
                self.diffch = False
                break
            if not self.mc4:
                if self.lang == "en":
                    self.m1 = "Do you want to change initial difficulty? "
                    self.m2 = "Set it right further mode (/d2, /d3, /d4, "
                    self.m3 = "/d5, /d[number]), /0 - if don't want to set new"
                elif self.lang == "ru":
                    self.m1 = "Вы хотите сменить стартовую сложность? Ставьте "
                    self.m2 = "сразу к дальнейшему моду (/d2, /d3, /d4, /d5, "
                    self.m3 = "/d[число]), /0 - если не хотите ставить новую"
                self.m = self.m1 + self.m2 + self.m3
                try:
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.mc4 = True
            try:  # try to extract number from latest message
                if self.rdlm == self.prevm:
                    raise IndexError("Got no new messages!")
                self.r = re.findall(r"([0-9]{1,6})", self.rdlm)
                self.d = int(self.r[0])
            except IndexError:
                if self.rdlm != self.prevm and self.rdlm != "/0":
                    await self.error()
                    await self.restart()
                continue
            if self.lang == "en":
                self.m = f"Have mode {self.d} init mode"
            elif self.lang == "ru":
                self.m = f"Выбран {self.d} стартовый мод"
            try:
                await self.sndm(self.m)
            except ConnectionError:
                continue
            break
        self.prevm = self.rdlm
        if self.mode == "vmul" or self.mode == "mmul":
            await self.msize()  # for matrix operations we need their size
        else:
            await self.count()  # for basic operation we start counting now

    async def msize(object self):
        """Matrix Size"""
        while True:
            try:
                await self.rdm()  # read latest message
            except ConnectionError:
                continue
            if self.rdlm == "/start":
                self.restart()  # check for restart command
            if not self.mc5:
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
                    continue
                self.mc5 = True
            try:  # try to extract number from latest message
                if self.rdlm == self.prevm:
                    raise IndexError("Got no new messages!")
                self.r = re.findall(r"^\/m([2-4])", self.rdlm)
                self.ms = int(self.r[0])
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
                    continue
            except IndexError:
                if self.rdlm != self.prevm and self.rdlm != "/0":
                    await self.error()
                    await self.restart()
                continue
            break
        await self.count()  # start counting now

    async def count(object self):
        """counting loop"""
        if self.diffch:  # define starting position
            self.st = (self.s * self.d) - (self.s - 1)
        else:
            self.st = 1
        for i in itertools.count(start=self.st, step=1):  # special loop
            if self.mode == "mul":  # check for counting mode option
                if self.cmul:  # convert initial numbers to usable for loop
                    self.n1, self.n2 = self.mnum[0], self.mnum[1]
                    self.cmul = False
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr % 2 == 1 and itr != 1:
                                self.n1 += 1
                            elif itr % 2 == 0 and itr != 1:
                                self.n2 += 1
                        else:
                            if itr % (self.s * 2) == 1 and itr != 1:
                                self.n1 += 1
                            elif itr % self.s == 1 and itr != 1:
                                self.n2 += 1
                if self.s == 1:  # special case
                    if i % 2 == 1 and i != self.st:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % 2 == 0 and i != self.st:
                        self.n2 += 1  # every 1st pass increase 2nd num
                else:  # for other values we use usual approach
                    if i % (self.s * 2) == 1 and i != self.st:
                        self.n1 += 1  # every 2nd pass increase 1st num
                    elif i % self.s == 1 and i != self.st:
                        self.n2 += 1  # every 1st pass increase 2nd num
                await ml(self)
            elif self.mode == "div":  # check for counting mode option
                if self.cdiv:  # convert initial numbers to usable for loop
                    self.n1, self.n2 = self.dnum[0], self.dnum[1]
                    self.cdiv = False
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr % 2 == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % 2 == 0 and itr != 1:
                                self.n1 += 1
                        else:
                            if itr % (self.s * 2) == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % self.s == 1 and itr != 1:
                                self.n1 += 1
                if self.s == 1:  # special case
                    if i % 2 == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % 2 == 0 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1st num
                else:  # for other values we use usual approach
                    if i % (self.s * 2) == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2nd num
                    elif i % self.s == 1 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1st num
                await dl(self)
            elif self.mode == "sqr":  # check for counting mode option
                if self.csqr:  # convert initial numbers to usable for loop
                    self.n1 = self.sqnum
                    self.csqr = False
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr != 1:
                                self.n1 += 1
                        else:
                            if itr % self.s == 1 and itr != 1:
                                self.n1 += 1
                if self.s == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.s == 1 and i != self.st:
                        self.n1 += 1  # every pass increase num
                await sqr(self)
            elif self.mode == "root":  # check for counting mode option
                if self.croot:  # convert initial numbers to usable for loop
                    self.n1 = self.ronum
                    self.croot = False
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr != 1:
                                self.n1 += 1
                        else:
                            if itr % self.s == 1 and itr != 1:
                                self.n1 += 1
                if self.s == 1:  # special case
                    if i != 1:
                        self.n1 += 1  # every pass increase num
                else:  # usual approach
                    if i % self.s == 1 and i != self.st:
                        self.n1 += 1  # every pass increase num
                await root(self)
            elif self.mode == "vmul":  # check for counting mode option
                if self.cvmul:  # convert initial numbers to usable for loop
                    self.n1, self.n2 = self.vmnum[0], self.vmnum[1]
                    self.cvmul = False  # change state not to reconvert vars
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr % 2 == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % 2 == 0 and itr != 1:
                                self.n1 += 1
                        else:
                            if itr % (self.s * 2) == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % self.s == 1 and itr != 1:
                                self.n1 += 1
                if self.s == 1:  # special case
                    if i % 2 == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2st num
                    elif i % 2 == 0 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1nd num
                else:  # for other values we use usual approach
                    if i % (self.s * 2) == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2st num
                    elif i % self.s == 1 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1nd num
                await vml(self)
            elif self.mode == "mmul":  # check for counting mode option
                if self.cmmul:  # convert initial numbers to usable for loop
                    self.n1, self.n2 = self.mmnum[0], self.mmnum[1]
                    self.cmmul = False  # change state not to reconvert vars
                if self.diffch:  # put bot through default loop
                    self.diffch = False
                    for itr in range(self.s * self.d):
                        if self.s == 1:
                            if itr % 2 == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % 2 == 0 and itr != 1:
                                self.n1 += 1
                        else:
                            if itr % (self.s * 2) == 1 and itr != 1:
                                self.n2 += 1
                            elif itr % self.s == 1 and itr != 1:
                                self.n1 += 1
                if self.s == 1:  # special case
                    if i % 2 == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2st num
                    elif i % 2 == 0 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1nd num
                else:  # for other values we use usual approach
                    if i % (self.s * 2) == 1 and i != self.st:
                        self.n2 += 1  # every 2nd pass increase 2st num
                    elif i % self.s == 1 and i != self.st:
                        self.n1 += 1  # every 1st pass increase 1nd num
                await mml(self)


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
pbot50 = Bot(token, 50)
pbot51 = Bot(token, 51)
pbot52 = Bot(token, 52)
pbot53 = Bot(token, 53)
pbot54 = Bot(token, 54)
pbot55 = Bot(token, 55)
pbot56 = Bot(token, 56)
pbot57 = Bot(token, 57)
pbot58 = Bot(token, 58)
pbot59 = Bot(token, 59)
pbot60 = Bot(token, 60)
pbot61 = Bot(token, 61)
pbot62 = Bot(token, 62)
pbot63 = Bot(token, 63)
pbot64 = Bot(token, 64)
pbot65 = Bot(token, 65)
pbot66 = Bot(token, 66)
pbot67 = Bot(token, 67)
pbot68 = Bot(token, 68)
pbot69 = Bot(token, 69)
pbot70 = Bot(token, 70)
pbot71 = Bot(token, 71)
pbot72 = Bot(token, 72)
pbot73 = Bot(token, 73)
pbot74 = Bot(token, 74)
pbot75 = Bot(token, 75)
pbot76 = Bot(token, 76)
pbot77 = Bot(token, 77)
pbot78 = Bot(token, 78)
pbot79 = Bot(token, 79)
pbot80 = Bot(token, 80)
pbot81 = Bot(token, 81)
pbot82 = Bot(token, 82)
pbot83 = Bot(token, 83)
pbot84 = Bot(token, 84)
pbot85 = Bot(token, 85)
pbot86 = Bot(token, 86)
pbot87 = Bot(token, 87)
pbot88 = Bot(token, 88)
pbot89 = Bot(token, 89)
pbot90 = Bot(token, 90)
pbot91 = Bot(token, 91)
pbot92 = Bot(token, 92)
pbot93 = Bot(token, 93)
pbot94 = Bot(token, 94)
pbot95 = Bot(token, 95)
pbot96 = Bot(token, 96)
pbot97 = Bot(token, 97)
pbot98 = Bot(token, 98)
pbot99 = Bot(token, 99)
pbot100 = Bot(token, 100)
pbot101 = Bot(token, 101)
pbot102 = Bot(token, 102)
pbot103 = Bot(token, 103)
pbot104 = Bot(token, 104)
pbot105 = Bot(token, 105)
pbot106 = Bot(token, 106)
pbot107 = Bot(token, 107)
pbot108 = Bot(token, 108)
pbot109 = Bot(token, 109)
pbot110 = Bot(token, 110)
pbot111 = Bot(token, 111)
pbot112 = Bot(token, 112)
pbot113 = Bot(token, 113)
pbot114 = Bot(token, 114)
pbot115 = Bot(token, 115)
pbot116 = Bot(token, 116)
pbot117 = Bot(token, 117)
pbot118 = Bot(token, 118)
pbot119 = Bot(token, 119)
pbot120 = Bot(token, 120)
pbot121 = Bot(token, 121)
pbot122 = Bot(token, 122)
pbot123 = Bot(token, 123)
pbot124 = Bot(token, 124)
pbot125 = Bot(token, 125)
pbot126 = Bot(token, 126)
pbot127 = Bot(token, 127)
pbot128 = Bot(token, 128)
pbot129 = Bot(token, 129)
pbot130 = Bot(token, 130)
pbot131 = Bot(token, 131)
pbot132 = Bot(token, 132)
pbot133 = Bot(token, 133)
pbot134 = Bot(token, 134)
pbot135 = Bot(token, 135)
pbot136 = Bot(token, 136)
pbot137 = Bot(token, 137)
pbot138 = Bot(token, 138)
pbot139 = Bot(token, 139)
pbot140 = Bot(token, 140)
pbot141 = Bot(token, 141)
pbot142 = Bot(token, 142)
pbot143 = Bot(token, 143)
pbot144 = Bot(token, 144)
pbot145 = Bot(token, 145)
pbot146 = Bot(token, 146)
pbot147 = Bot(token, 147)
pbot148 = Bot(token, 148)
pbot149 = Bot(token, 149)
pbot150 = Bot(token, 150)
pbot151 = Bot(token, 151)
pbot152 = Bot(token, 152)
pbot153 = Bot(token, 153)
pbot154 = Bot(token, 154)
pbot155 = Bot(token, 155)
pbot156 = Bot(token, 156)
pbot157 = Bot(token, 157)
pbot158 = Bot(token, 158)
pbot159 = Bot(token, 159)
pbot160 = Bot(token, 160)
pbot161 = Bot(token, 161)
pbot162 = Bot(token, 162)
pbot163 = Bot(token, 163)
pbot164 = Bot(token, 164)
pbot165 = Bot(token, 165)
pbot166 = Bot(token, 166)
pbot167 = Bot(token, 167)
pbot168 = Bot(token, 168)
pbot169 = Bot(token, 169)
pbot170 = Bot(token, 170)
pbot171 = Bot(token, 171)
pbot172 = Bot(token, 172)
pbot173 = Bot(token, 173)
pbot174 = Bot(token, 174)
pbot175 = Bot(token, 175)
pbot176 = Bot(token, 176)
pbot177 = Bot(token, 127)
pbot178 = Bot(token, 178)
pbot179 = Bot(token, 179)
pbot180 = Bot(token, 180)
pbot181 = Bot(token, 181)
pbot182 = Bot(token, 182)
pbot183 = Bot(token, 183)
pbot184 = Bot(token, 184)
pbot185 = Bot(token, 185)
pbot186 = Bot(token, 186)
pbot187 = Bot(token, 187)
pbot188 = Bot(token, 188)
pbot189 = Bot(token, 189)
pbot190 = Bot(token, 190)
pbot191 = Bot(token, 191)
pbot192 = Bot(token, 192)
pbot193 = Bot(token, 193)
pbot194 = Bot(token, 194)
pbot195 = Bot(token, 195)
pbot196 = Bot(token, 196)
pbot197 = Bot(token, 197)
pbot198 = Bot(token, 198)
pbot199 = Bot(token, 199)
pbot200 = Bot(token, 200)
pbot201 = Bot(token, 201)
pbot202 = Bot(token, 202)
pbot203 = Bot(token, 203)
pbot204 = Bot(token, 204)
pbot205 = Bot(token, 205)
pbot206 = Bot(token, 206)
pbot207 = Bot(token, 207)
pbot208 = Bot(token, 208)
pbot209 = Bot(token, 209)
pbot210 = Bot(token, 210)
pbot211 = Bot(token, 211)
pbot212 = Bot(token, 212)
pbot213 = Bot(token, 213)
pbot214 = Bot(token, 214)
pbot215 = Bot(token, 215)
pbot216 = Bot(token, 216)
pbot217 = Bot(token, 217)
pbot218 = Bot(token, 218)
pbot219 = Bot(token, 219)
pbot220 = Bot(token, 220)
pbot221 = Bot(token, 221)
pbot222 = Bot(token, 222)
pbot223 = Bot(token, 223)
pbot224 = Bot(token, 224)
pbot225 = Bot(token, 225)
pbot226 = Bot(token, 226)
pbot227 = Bot(token, 227)
pbot228 = Bot(token, 228)
pbot229 = Bot(token, 229)
pbot230 = Bot(token, 230)
pbot231 = Bot(token, 231)
pbot232 = Bot(token, 232)
pbot233 = Bot(token, 233)
pbot234 = Bot(token, 234)
pbot235 = Bot(token, 235)
pbot236 = Bot(token, 236)
pbot237 = Bot(token, 237)
pbot238 = Bot(token, 238)
pbot239 = Bot(token, 239)
pbot240 = Bot(token, 240)
pbot241 = Bot(token, 241)
pbot242 = Bot(token, 242)
pbot243 = Bot(token, 243)
pbot244 = Bot(token, 244)
pbot245 = Bot(token, 245)
pbot246 = Bot(token, 246)
pbot247 = Bot(token, 247)
pbot248 = Bot(token, 248)
pbot249 = Bot(token, 249)
pbot250 = Bot(token, 250)
pbot251 = Bot(token, 251)
pbot252 = Bot(token, 252)
pbot253 = Bot(token, 253)
pbot254 = Bot(token, 254)
pbot255 = Bot(token, 255)
pbot256 = Bot(token, 256)
pbot257 = Bot(token, 257)
pbot258 = Bot(token, 258)
pbot259 = Bot(token, 259)
pbot260 = Bot(token, 260)
pbot261 = Bot(token, 261)
pbot262 = Bot(token, 262)
pbot263 = Bot(token, 263)
pbot264 = Bot(token, 264)
pbot265 = Bot(token, 265)
pbot266 = Bot(token, 266)
pbot267 = Bot(token, 267)
pbot268 = Bot(token, 268)
pbot269 = Bot(token, 269)
pbot270 = Bot(token, 270)
pbot271 = Bot(token, 271)
pbot272 = Bot(token, 272)
pbot273 = Bot(token, 273)
pbot274 = Bot(token, 274)
pbot275 = Bot(token, 275)
pbot276 = Bot(token, 276)
pbot277 = Bot(token, 277)
pbot278 = Bot(token, 278)
pbot279 = Bot(token, 279)
pbot280 = Bot(token, 280)
pbot281 = Bot(token, 281)
pbot282 = Bot(token, 282)
pbot283 = Bot(token, 283)
pbot284 = Bot(token, 284)
pbot285 = Bot(token, 285)
pbot286 = Bot(token, 286)
pbot287 = Bot(token, 287)
pbot288 = Bot(token, 288)
pbot289 = Bot(token, 289)
pbot290 = Bot(token, 280)
pbot291 = Bot(token, 291)
pbot292 = Bot(token, 292)
pbot293 = Bot(token, 293)
pbot294 = Bot(token, 294)
pbot295 = Bot(token, 295)
pbot296 = Bot(token, 296)
pbot297 = Bot(token, 297)
pbot298 = Bot(token, 298)
pbot299 = Bot(token, 299)
pbot300 = Bot(token, 300)
pbot301 = Bot(token, 301)
pbot302 = Bot(token, 302)
pbot303 = Bot(token, 303)
pbot304 = Bot(token, 304)
pbot305 = Bot(token, 305)
pbot306 = Bot(token, 306)
pbot307 = Bot(token, 307)
pbot308 = Bot(token, 308)
pbot309 = Bot(token, 309)
pbot310 = Bot(token, 310)
pbot311 = Bot(token, 311)
pbot312 = Bot(token, 312)
pbot313 = Bot(token, 313)
pbot314 = Bot(token, 314)
pbot315 = Bot(token, 315)
pbot316 = Bot(token, 316)
pbot317 = Bot(token, 317)
pbot318 = Bot(token, 318)
pbot319 = Bot(token, 319)
pbot320 = Bot(token, 320)
pbot321 = Bot(token, 321)
pbot322 = Bot(token, 322)
pbot323 = Bot(token, 223)
pbot324 = Bot(token, 324)
pbot325 = Bot(token, 325)
pbot326 = Bot(token, 326)
pbot327 = Bot(token, 327)
pbot328 = Bot(token, 328)
pbot329 = Bot(token, 329)
pbot330 = Bot(token, 330)
pbot331 = Bot(token, 331)
pbot332 = Bot(token, 332)
pbot333 = Bot(token, 333)
pbot334 = Bot(token, 334)
pbot335 = Bot(token, 335)
pbot336 = Bot(token, 336)
pbot337 = Bot(token, 337)
pbot338 = Bot(token, 338)
pbot339 = Bot(token, 339)
pbot340 = Bot(token, 330)
pbot341 = Bot(token, 341)
pbot342 = Bot(token, 342)
pbot343 = Bot(token, 343)
pbot344 = Bot(token, 344)
pbot345 = Bot(token, 345)
pbot346 = Bot(token, 346)
pbot347 = Bot(token, 347)
pbot348 = Bot(token, 348)
pbot349 = Bot(token, 349)
pbot350 = Bot(token, 350)
pbot351 = Bot(token, 351)
pbot352 = Bot(token, 352)
pbot353 = Bot(token, 353)
pbot354 = Bot(token, 354)
pbot355 = Bot(token, 355)
pbot356 = Bot(token, 356)
pbot357 = Bot(token, 357)
pbot358 = Bot(token, 358)
pbot359 = Bot(token, 359)
pbot360 = Bot(token, 360)
pbot361 = Bot(token, 361)
pbot362 = Bot(token, 362)
pbot363 = Bot(token, 363)
pbot364 = Bot(token, 364)
pbot365 = Bot(token, 365)
pbot366 = Bot(token, 366)
pbot367 = Bot(token, 367)
pbot368 = Bot(token, 368)
pbot369 = Bot(token, 369)
pbot370 = Bot(token, 370)
pbot371 = Bot(token, 371)
pbot372 = Bot(token, 372)
pbot373 = Bot(token, 273)
pbot374 = Bot(token, 374)
pbot375 = Bot(token, 375)
pbot376 = Bot(token, 376)
pbot377 = Bot(token, 377)
pbot378 = Bot(token, 378)
pbot379 = Bot(token, 379)
pbot380 = Bot(token, 380)
pbot381 = Bot(token, 381)
pbot382 = Bot(token, 382)
pbot383 = Bot(token, 383)
pbot384 = Bot(token, 384)
pbot385 = Bot(token, 385)
pbot386 = Bot(token, 386)
pbot387 = Bot(token, 387)
pbot388 = Bot(token, 388)
pbot389 = Bot(token, 389)
pbot390 = Bot(token, 380)
pbot391 = Bot(token, 391)
pbot392 = Bot(token, 392)
pbot393 = Bot(token, 393)
pbot394 = Bot(token, 394)
pbot395 = Bot(token, 395)
pbot396 = Bot(token, 396)
pbot397 = Bot(token, 397)
pbot398 = Bot(token, 398)
pbot399 = Bot(token, 399)
pbot400 = Bot(token, 400)
pbot401 = Bot(token, 401)
pbot402 = Bot(token, 402)
pbot403 = Bot(token, 403)
pbot404 = Bot(token, 404)
pbot405 = Bot(token, 405)
pbot406 = Bot(token, 406)
pbot407 = Bot(token, 407)
pbot408 = Bot(token, 408)
pbot409 = Bot(token, 409)
pbot410 = Bot(token, 410)
pbot411 = Bot(token, 411)
pbot412 = Bot(token, 412)
pbot413 = Bot(token, 413)
pbot414 = Bot(token, 414)
pbot415 = Bot(token, 415)
pbot416 = Bot(token, 416)
pbot417 = Bot(token, 417)
pbot418 = Bot(token, 418)
pbot419 = Bot(token, 419)
pbot420 = Bot(token, 420)
pbot421 = Bot(token, 421)
pbot422 = Bot(token, 422)
pbot423 = Bot(token, 423)
pbot424 = Bot(token, 424)
pbot425 = Bot(token, 425)
pbot426 = Bot(token, 426)
pbot427 = Bot(token, 427)
pbot428 = Bot(token, 428)
pbot429 = Bot(token, 429)
pbot430 = Bot(token, 430)
pbot431 = Bot(token, 431)
pbot432 = Bot(token, 432)
pbot433 = Bot(token, 433)
pbot434 = Bot(token, 434)
pbot435 = Bot(token, 435)
pbot436 = Bot(token, 436)
pbot437 = Bot(token, 437)
pbot438 = Bot(token, 438)
pbot439 = Bot(token, 439)
pbot440 = Bot(token, 430)
pbot441 = Bot(token, 441)
pbot442 = Bot(token, 442)
pbot443 = Bot(token, 443)
pbot444 = Bot(token, 444)
pbot445 = Bot(token, 445)
pbot446 = Bot(token, 446)
pbot447 = Bot(token, 447)
pbot448 = Bot(token, 448)
pbot449 = Bot(token, 449)
pbot450 = Bot(token, 450)
pbot451 = Bot(token, 451)
pbot452 = Bot(token, 452)
pbot453 = Bot(token, 453)
pbot454 = Bot(token, 454)
pbot455 = Bot(token, 455)
pbot456 = Bot(token, 456)
pbot457 = Bot(token, 457)
pbot458 = Bot(token, 458)
pbot459 = Bot(token, 459)
pbot460 = Bot(token, 460)
pbot461 = Bot(token, 461)
pbot462 = Bot(token, 462)
pbot463 = Bot(token, 463)
pbot464 = Bot(token, 464)
pbot465 = Bot(token, 465)
pbot466 = Bot(token, 466)
pbot467 = Bot(token, 467)
pbot468 = Bot(token, 468)
pbot469 = Bot(token, 469)
pbot470 = Bot(token, 470)
pbot471 = Bot(token, 471)
pbot472 = Bot(token, 472)
pbot473 = Bot(token, 473)
pbot474 = Bot(token, 474)
pbot475 = Bot(token, 475)
pbot476 = Bot(token, 476)
pbot477 = Bot(token, 477)
pbot478 = Bot(token, 478)
pbot479 = Bot(token, 479)
pbot480 = Bot(token, 480)
pbot481 = Bot(token, 481)
pbot482 = Bot(token, 482)
pbot483 = Bot(token, 483)
pbot484 = Bot(token, 484)
pbot485 = Bot(token, 485)
pbot486 = Bot(token, 486)
pbot487 = Bot(token, 487)
pbot488 = Bot(token, 488)
pbot489 = Bot(token, 489)
pbot490 = Bot(token, 490)
pbot491 = Bot(token, 491)
pbot492 = Bot(token, 492)
pbot493 = Bot(token, 493)
pbot494 = Bot(token, 494)
pbot495 = Bot(token, 495)
pbot496 = Bot(token, 496)
pbot497 = Bot(token, 497)
pbot498 = Bot(token, 498)
pbot499 = Bot(token, 499)

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
        pbot49.start(),
        pbot50.start(),
        pbot51.start(),
        pbot52.start(),
        pbot53.start(),
        pbot54.start(),
        pbot55.start(),
        pbot56.start(),
        pbot57.start(),
        pbot58.start(),
        pbot59.start(),
        pbot60.start(),
        pbot61.start(),
        pbot62.start(),
        pbot63.start(),
        pbot64.start(),
        pbot65.start(),
        pbot66.start(),
        pbot67.start(),
        pbot68.start(),
        pbot69.start(),
        pbot70.start(),
        pbot71.start(),
        pbot72.start(),
        pbot73.start(),
        pbot74.start(),
        pbot75.start(),
        pbot76.start(),
        pbot77.start(),
        pbot78.start(),
        pbot79.start(),
        pbot80.start(),
        pbot81.start(),
        pbot82.start(),
        pbot83.start(),
        pbot84.start(),
        pbot85.start(),
        pbot86.start(),
        pbot87.start(),
        pbot88.start(),
        pbot89.start(),
        pbot90.start(),
        pbot91.start(),
        pbot92.start(),
        pbot93.start(),
        pbot94.start(),
        pbot95.start(),
        pbot96.start(),
        pbot97.start(),
        pbot98.start(),
        pbot99.start(),
        pbot100.start(),
        pbot101.start(),
        pbot102.start(),
        pbot103.start(),
        pbot104.start(),
        pbot105.start(),
        pbot106.start(),
        pbot107.start(),
        pbot108.start(),
        pbot109.start(),
        pbot110.start(),
        pbot111.start(),
        pbot112.start(),
        pbot113.start(),
        pbot114.start(),
        pbot115.start(),
        pbot116.start(),
        pbot117.start(),
        pbot118.start(),
        pbot119.start(),
        pbot120.start(),
        pbot121.start(),
        pbot122.start(),
        pbot123.start(),
        pbot124.start(),
        pbot125.start(),
        pbot126.start(),
        pbot127.start(),
        pbot128.start(),
        pbot129.start(),
        pbot130.start(),
        pbot131.start(),
        pbot132.start(),
        pbot133.start(),
        pbot134.start(),
        pbot135.start(),
        pbot136.start(),
        pbot137.start(),
        pbot138.start(),
        pbot139.start(),
        pbot140.start(),
        pbot141.start(),
        pbot142.start(),
        pbot143.start(),
        pbot144.start(),
        pbot145.start(),
        pbot146.start(),
        pbot147.start(),
        pbot148.start(),
        pbot149.start(),
        pbot150.start(),
        pbot151.start(),
        pbot152.start(),
        pbot153.start(),
        pbot154.start(),
        pbot155.start(),
        pbot156.start(),
        pbot157.start(),
        pbot158.start(),
        pbot159.start(),
        pbot160.start(),
        pbot161.start(),
        pbot162.start(),
        pbot163.start(),
        pbot164.start(),
        pbot165.start(),
        pbot166.start(),
        pbot167.start(),
        pbot168.start(),
        pbot169.start(),
        pbot170.start(),
        pbot171.start(),
        pbot172.start(),
        pbot173.start(),
        pbot174.start(),
        pbot175.start(),
        pbot176.start(),
        pbot177.start(),
        pbot178.start(),
        pbot179.start(),
        pbot180.start(),
        pbot181.start(),
        pbot182.start(),
        pbot183.start(),
        pbot184.start(),
        pbot185.start(),
        pbot186.start(),
        pbot187.start(),
        pbot188.start(),
        pbot189.start(),
        pbot190.start(),
        pbot191.start(),
        pbot192.start(),
        pbot193.start(),
        pbot194.start(),
        pbot195.start(),
        pbot196.start(),
        pbot197.start(),
        pbot198.start(),
        pbot199.start(),
        pbot200.start(),
        pbot201.start(),
        pbot202.start(),
        pbot203.start(),
        pbot204.start(),
        pbot205.start(),
        pbot206.start(),
        pbot207.start(),
        pbot208.start(),
        pbot209.start(),
        pbot210.start(),
        pbot211.start(),
        pbot212.start(),
        pbot213.start(),
        pbot214.start(),
        pbot215.start(),
        pbot216.start(),
        pbot217.start(),
        pbot218.start(),
        pbot219.start(),
        pbot220.start(),
        pbot221.start(),
        pbot222.start(),
        pbot223.start(),
        pbot224.start(),
        pbot225.start(),
        pbot226.start(),
        pbot227.start(),
        pbot228.start(),
        pbot229.start(),
        pbot230.start(),
        pbot231.start(),
        pbot232.start(),
        pbot233.start(),
        pbot234.start(),
        pbot235.start(),
        pbot236.start(),
        pbot237.start(),
        pbot238.start(),
        pbot239.start(),
        pbot240.start(),
        pbot241.start(),
        pbot242.start(),
        pbot243.start(),
        pbot244.start(),
        pbot245.start(),
        pbot246.start(),
        pbot247.start(),
        pbot248.start(),
        pbot249.start(),
        pbot250.start(),
        pbot251.start(),
        pbot252.start(),
        pbot253.start(),
        pbot254.start(),
        pbot255.start(),
        pbot256.start(),
        pbot257.start(),
        pbot258.start(),
        pbot259.start(),
        pbot260.start(),
        pbot261.start(),
        pbot262.start(),
        pbot263.start(),
        pbot264.start(),
        pbot265.start(),
        pbot266.start(),
        pbot267.start(),
        pbot268.start(),
        pbot269.start(),
        pbot270.start(),
        pbot271.start(),
        pbot272.start(),
        pbot273.start(),
        pbot274.start(),
        pbot275.start(),
        pbot276.start(),
        pbot277.start(),
        pbot278.start(),
        pbot279.start(),
        pbot280.start(),
        pbot281.start(),
        pbot282.start(),
        pbot283.start(),
        pbot284.start(),
        pbot285.start(),
        pbot286.start(),
        pbot287.start(),
        pbot288.start(),
        pbot289.start(),
        pbot290.start(),
        pbot291.start(),
        pbot292.start(),
        pbot293.start(),
        pbot294.start(),
        pbot295.start(),
        pbot296.start(),
        pbot297.start(),
        pbot298.start(),
        pbot299.start(),
        pbot300.start(),
        pbot301.start(),
        pbot302.start(),
        pbot303.start(),
        pbot304.start(),
        pbot305.start(),
        pbot306.start(),
        pbot307.start(),
        pbot308.start(),
        pbot309.start(),
        pbot310.start(),
        pbot311.start(),
        pbot312.start(),
        pbot313.start(),
        pbot314.start(),
        pbot315.start(),
        pbot316.start(),
        pbot317.start(),
        pbot318.start(),
        pbot319.start(),
        pbot320.start(),
        pbot321.start(),
        pbot322.start(),
        pbot323.start(),
        pbot324.start(),
        pbot325.start(),
        pbot326.start(),
        pbot327.start(),
        pbot328.start(),
        pbot329.start(),
        pbot330.start(),
        pbot331.start(),
        pbot332.start(),
        pbot333.start(),
        pbot334.start(),
        pbot335.start(),
        pbot336.start(),
        pbot337.start(),
        pbot338.start(),
        pbot339.start(),
        pbot340.start(),
        pbot341.start(),
        pbot342.start(),
        pbot343.start(),
        pbot344.start(),
        pbot345.start(),
        pbot346.start(),
        pbot347.start(),
        pbot348.start(),
        pbot349.start(),
        pbot350.start(),
        pbot351.start(),
        pbot352.start(),
        pbot353.start(),
        pbot354.start(),
        pbot355.start(),
        pbot356.start(),
        pbot357.start(),
        pbot358.start(),
        pbot359.start(),
        pbot360.start(),
        pbot361.start(),
        pbot362.start(),
        pbot363.start(),
        pbot364.start(),
        pbot365.start(),
        pbot366.start(),
        pbot367.start(),
        pbot368.start(),
        pbot369.start(),
        pbot370.start(),
        pbot371.start(),
        pbot372.start(),
        pbot373.start(),
        pbot374.start(),
        pbot375.start(),
        pbot376.start(),
        pbot377.start(),
        pbot378.start(),
        pbot379.start(),
        pbot380.start(),
        pbot381.start(),
        pbot382.start(),
        pbot383.start(),
        pbot384.start(),
        pbot385.start(),
        pbot386.start(),
        pbot387.start(),
        pbot388.start(),
        pbot389.start(),
        pbot390.start(),
        pbot391.start(),
        pbot392.start(),
        pbot393.start(),
        pbot394.start(),
        pbot395.start(),
        pbot396.start(),
        pbot397.start(),
        pbot398.start(),
        pbot399.start(),
        pbot400.start(),
        pbot401.start(),
        pbot402.start(),
        pbot403.start(),
        pbot404.start(),
        pbot405.start(),
        pbot406.start(),
        pbot407.start(),
        pbot408.start(),
        pbot409.start(),
        pbot410.start(),
        pbot411.start(),
        pbot412.start(),
        pbot413.start(),
        pbot414.start(),
        pbot415.start(),
        pbot416.start(),
        pbot417.start(),
        pbot418.start(),
        pbot419.start(),
        pbot420.start(),
        pbot421.start(),
        pbot422.start(),
        pbot423.start(),
        pbot424.start(),
        pbot425.start(),
        pbot426.start(),
        pbot427.start(),
        pbot428.start(),
        pbot429.start(),
        pbot430.start(),
        pbot431.start(),
        pbot432.start(),
        pbot433.start(),
        pbot434.start(),
        pbot435.start(),
        pbot436.start(),
        pbot437.start(),
        pbot438.start(),
        pbot439.start(),
        pbot440.start(),
        pbot441.start(),
        pbot442.start(),
        pbot443.start(),
        pbot444.start(),
        pbot445.start(),
        pbot446.start(),
        pbot447.start(),
        pbot448.start(),
        pbot449.start(),
        pbot450.start(),
        pbot451.start(),
        pbot452.start(),
        pbot453.start(),
        pbot454.start(),
        pbot455.start(),
        pbot456.start(),
        pbot457.start(),
        pbot458.start(),
        pbot459.start(),
        pbot460.start(),
        pbot461.start(),
        pbot462.start(),
        pbot463.start(),
        pbot464.start(),
        pbot465.start(),
        pbot466.start(),
        pbot467.start(),
        pbot468.start(),
        pbot469.start(),
        pbot470.start(),
        pbot471.start(),
        pbot472.start(),
        pbot473.start(),
        pbot474.start(),
        pbot475.start(),
        pbot476.start(),
        pbot477.start(),
        pbot478.start(),
        pbot479.start(),
        pbot480.start(),
        pbot481.start(),
        pbot482.start(),
        pbot483.start(),
        pbot484.start(),
        pbot485.start(),
        pbot486.start(),
        pbot487.start(),
        pbot488.start(),
        pbot489.start(),
        pbot490.start(),
        pbot491.start(),
        pbot492.start(),
        pbot493.start(),
        pbot494.start(),
        pbot495.start(),
        pbot496.start(),
        pbot497.start(),
        pbot498.start(),
        pbot499.start()
        )


asyncio.run(main())
