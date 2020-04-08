import re
import json
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
            ch = np.random.choice(("2x3", "3x2"), 1, p=[0.5, 0.5])
            fch = str(ch[0])
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
            ch = np.random.choice(("2x3", "3x2"), 1, p=[0.5, 0.5])
            fch = str(ch[0])
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
    cdef public int CID
    cdef public list cids
    cdef public double TIMEOUT
    """define message urls and message variables"""
    cdef public str URL, URLR, ERROR_EN, ERROR_RU, MISTYPE_EN, MISTYPE_RU
    """define right answers and user-supplied ones"""
    cdef public int c, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cdef public int u, u1, u2, u3, u4, u5, u6, u7, u8, u9
    """define all messages and message related variables"""
    cdef public str m, m1, m2, m3, m4, m5, prevm, rdlm
    cdef public int mc2, mc3, mc4, mc5
    """define all mode and mode of count related variables"""
    cdef public tuple mnum, dnum, sqnum, ronum, vmnum, mmnum
    cdef public int st, n1, n2
    """define restart variable and convertion ones for different modes"""
    cdef public int resch, cmul, cdiv, csqr, croot, cvmul, cmmul
    """define all time related variables"""
    cdef public int date, ldate, pdate
    """define all choice related variables"""
    cdef public str lang, mode
    cdef public int s, d, ms, diffch
    cdef public list r

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
        self.prevm = ""  # set to such value because of Cython specifics
        self.cids = []
        self.c, self.u = 0, 0
        self.c1, self.c2, self.c3 = 0, 0, 0
        self.c4, self.c5, self.c6 = 0, 0, 0
        self.c7, self.c8, self.c9 = 0, 0, 0
        self.u1, self.u2, self.u3 = 0, 0, 0
        self.u4, self.u5, self.u6 = 0, 0, 0
        self.u7, self.u8, self.u9 = 0, 0, 0
        self.mnum = (2, 1)
        self.dnum = (4, 2)
        self.vmnum = (1, 1)
        self.mmnum = (1, 1)
        self.sqnum = (2, )
        self.ronum = (2, )
        self.mc2 = False
        self.mc3 = False
        self.mc4 = False
        self.mc5 = False
        self.resch = False
        self.cmul = True
        self.cdiv = True
        self.cvmul = True
        self.cmmul = True
        self.csqr = True
        self.croot = True
        self.diffch = True

    async def rdc(object self):
        while True:
            """first request for getting chat ids (cids) is done here"""
            await asyncio.sleep(self.TIMEOUT)
            with open("cids.log", "r") as f:
                self.cids = f.read().rstrip().split("\n")
            try:
                self.CID = int(self.cids[self.NUMBER])  # we pick one cid num-based
                break
            except IndexError:
                continue
            except ValueError:
                continue

    async def rdm(object self):
        """new reqest to get fresh json data"""
        await asyncio.sleep(self.TIMEOUT)
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
            if cid == self.CID:  # check date only if CID in message match
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
        await self.rdc()
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
                    self.m1 = "Do you want linear algebra operations: "
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
                    self.m1 = "How many equations do you want before "
                    self.m2 = "increasing difficulty? (/s1, /s3, /s5, "
                    self.m3 = "/s10, /s15, /s20, /s25, /s50, /s[number])"
                elif self.lang == "ru":
                    self.m1 = "Как много примеров прежде чем "
                    self.m2 = "увеличить сложность? (/s1, /s3, /s5, "
                    self.m3 = "/s10, /s15, /s20, /s25, /s50, /s[число])"
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
                    self.m = f"Difficulty increasing speed {self.s} is chosen"
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
            if not self.mc4:
                if self.lang == "en":
                    self.m1 = "What starting difficulty do you want? (/d1, "
                    self.m2 = "/d2, /d3, /d4, /d5, /d6, /d7, /d8, /d[number])"
                elif self.lang == "ru":
                    self.m1 = "Какую стартовую сложность вы хотите? (/d1, "
                    self.m2 = "/d2, /d3, /d4, /d5, /d6, /d7, /d8, /d[число])"
                self.m = self.m1 + self.m2
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
                if self.rdlm != self.prevm and self.rdlm != "/start":
                    await self.error()
                    await self.restart()
                continue
            if self.d == 1:
                self.diffch = False
            if self.lang == "en":
                self.m = f"Starting difficulty {self.d} is chosen"
            elif self.lang == "ru":
                self.m = f"Выбрана {self.d} стартовая сложность"
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
                await self.restart()  # check for restart command
            if not self.mc5:
                if self.lang == "en":
                    self.m1 = "How big the matrix should be?"
                    self.m2 = " 2 or 3 or 2/3 (4)?"
                elif self.lang == "ru":
                    self.m1 = "Каков должен быть размер матрицы"
                    self.m2 = " 2 или 3 или 2/3?"
                self.m3 = " (/m2, /m3, /m4)"
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
            except IndexError:
                if self.rdlm != self.prevm and self.rdlm != "/start":
                    await self.error()
                    await self.restart()
                continue
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
            try:
                await self.sndm(self.m)
            except ConnectionError:
                continue
            break
        await self.count()  # start counting now

    async def count(object self):
        """counting loop"""
        if self.diffch:  # define starting position
            self.st = (self.s * self.d) - (self.s - 1)
        else:
            self.st = 1
        i = self.st
        while True:
            if self.mode == "mul":  # check for counting mode option
                if self.cmul:  # convert initial numbers to usable for loop
                    self.n1, self.n2 = self.mnum[0], self.mnum[1]
                    print(self.n1, self.n2)
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
                    self.n1 = self.sqnum[0]
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
                    self.n1 = self.ronum[0]
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
            i += 1


bot0 = Bot(token, 0)
bot1 = Bot(token, 1)
bot2 = Bot(token, 2)
bot3 = Bot(token, 3)
bot4 = Bot(token, 4)
bot5 = Bot(token, 5)
bot6 = Bot(token, 6)
bot7 = Bot(token, 7)
bot8 = Bot(token, 8)
bot9 = Bot(token, 9)
bot10 = Bot(token, 10)
bot11 = Bot(token, 11)
bot12 = Bot(token, 12)
bot13 = Bot(token, 13)
bot14 = Bot(token, 14)
bot15 = Bot(token, 15)
bot16 = Bot(token, 16)
bot17 = Bot(token, 17)
bot18 = Bot(token, 18)
bot19 = Bot(token, 19)
bot20 = Bot(token, 20)
bot21 = Bot(token, 21)
bot22 = Bot(token, 22)
bot23 = Bot(token, 23)
bot24 = Bot(token, 24)
bot25 = Bot(token, 25)
bot26 = Bot(token, 26)
bot27 = Bot(token, 27)
bot28 = Bot(token, 28)
bot29 = Bot(token, 29)
bot30 = Bot(token, 30)
bot31 = Bot(token, 31)
bot32 = Bot(token, 32)
bot33 = Bot(token, 33)
bot34 = Bot(token, 34)
bot35 = Bot(token, 35)
bot36 = Bot(token, 36)
bot37 = Bot(token, 37)
bot38 = Bot(token, 38)
bot39 = Bot(token, 39)
bot40 = Bot(token, 40)
bot41 = Bot(token, 41)
bot42 = Bot(token, 42)
bot43 = Bot(token, 43)
bot44 = Bot(token, 44)
bot45 = Bot(token, 45)
bot46 = Bot(token, 46)
bot47 = Bot(token, 47)
bot48 = Bot(token, 48)
bot49 = Bot(token, 49)
bot50 = Bot(token, 50)
bot51 = Bot(token, 51)
bot52 = Bot(token, 52)
bot53 = Bot(token, 53)
bot54 = Bot(token, 54)
bot55 = Bot(token, 55)
bot56 = Bot(token, 56)
bot57 = Bot(token, 57)
bot58 = Bot(token, 58)
bot59 = Bot(token, 59)
bot60 = Bot(token, 60)
bot61 = Bot(token, 61)
bot62 = Bot(token, 62)
bot63 = Bot(token, 63)
bot64 = Bot(token, 64)
bot65 = Bot(token, 65)
bot66 = Bot(token, 66)
bot67 = Bot(token, 67)
bot68 = Bot(token, 68)
bot69 = Bot(token, 69)
bot70 = Bot(token, 70)
bot71 = Bot(token, 71)
bot72 = Bot(token, 72)
bot73 = Bot(token, 73)
bot74 = Bot(token, 74)
bot75 = Bot(token, 75)
bot76 = Bot(token, 76)
bot77 = Bot(token, 77)
bot78 = Bot(token, 78)
bot79 = Bot(token, 79)
bot80 = Bot(token, 80)
bot81 = Bot(token, 81)
bot82 = Bot(token, 82)
bot83 = Bot(token, 83)
bot84 = Bot(token, 84)
bot85 = Bot(token, 85)
bot86 = Bot(token, 86)
bot87 = Bot(token, 87)
bot88 = Bot(token, 88)
bot89 = Bot(token, 89)
bot90 = Bot(token, 90)
bot91 = Bot(token, 91)
bot92 = Bot(token, 92)
bot93 = Bot(token, 93)
bot94 = Bot(token, 94)
bot95 = Bot(token, 95)
bot96 = Bot(token, 96)
bot97 = Bot(token, 97)
bot98 = Bot(token, 98)
bot99 = Bot(token, 99)
bot100 = Bot(token, 100)
bot101 = Bot(token, 101)
bot102 = Bot(token, 102)
bot103 = Bot(token, 103)
bot104 = Bot(token, 104)
bot105 = Bot(token, 105)
bot106 = Bot(token, 106)
bot107 = Bot(token, 107)
bot108 = Bot(token, 108)
bot109 = Bot(token, 109)
bot110 = Bot(token, 110)
bot111 = Bot(token, 111)
bot112 = Bot(token, 112)
bot113 = Bot(token, 113)
bot114 = Bot(token, 114)
bot115 = Bot(token, 115)
bot116 = Bot(token, 116)
bot117 = Bot(token, 117)
bot118 = Bot(token, 118)
bot119 = Bot(token, 119)
bot120 = Bot(token, 120)
bot121 = Bot(token, 121)
bot122 = Bot(token, 122)
bot123 = Bot(token, 123)
bot124 = Bot(token, 124)
bot125 = Bot(token, 125)
bot126 = Bot(token, 126)
bot127 = Bot(token, 127)
bot128 = Bot(token, 128)
bot129 = Bot(token, 129)
bot130 = Bot(token, 130)
bot131 = Bot(token, 131)
bot132 = Bot(token, 132)
bot133 = Bot(token, 133)
bot134 = Bot(token, 134)
bot135 = Bot(token, 135)
bot136 = Bot(token, 136)
bot137 = Bot(token, 137)
bot138 = Bot(token, 138)
bot139 = Bot(token, 139)
bot140 = Bot(token, 140)
bot141 = Bot(token, 141)
bot142 = Bot(token, 142)
bot143 = Bot(token, 143)
bot144 = Bot(token, 144)
bot145 = Bot(token, 145)
bot146 = Bot(token, 146)
bot147 = Bot(token, 147)
bot148 = Bot(token, 148)
bot149 = Bot(token, 149)
bot150 = Bot(token, 150)
bot151 = Bot(token, 151)
bot152 = Bot(token, 152)
bot153 = Bot(token, 153)
bot154 = Bot(token, 154)
bot155 = Bot(token, 155)
bot156 = Bot(token, 156)
bot157 = Bot(token, 157)
bot158 = Bot(token, 158)
bot159 = Bot(token, 159)
bot160 = Bot(token, 160)
bot161 = Bot(token, 161)
bot162 = Bot(token, 162)
bot163 = Bot(token, 163)
bot164 = Bot(token, 164)
bot165 = Bot(token, 165)
bot166 = Bot(token, 166)
bot167 = Bot(token, 167)
bot168 = Bot(token, 168)
bot169 = Bot(token, 169)
bot170 = Bot(token, 170)
bot171 = Bot(token, 171)
bot172 = Bot(token, 172)
bot173 = Bot(token, 173)
bot174 = Bot(token, 174)
bot175 = Bot(token, 175)
bot176 = Bot(token, 176)
bot177 = Bot(token, 127)
bot178 = Bot(token, 178)
bot179 = Bot(token, 179)
bot180 = Bot(token, 180)
bot181 = Bot(token, 181)
bot182 = Bot(token, 182)
bot183 = Bot(token, 183)
bot184 = Bot(token, 184)
bot185 = Bot(token, 185)
bot186 = Bot(token, 186)
bot187 = Bot(token, 187)
bot188 = Bot(token, 188)
bot189 = Bot(token, 189)
bot190 = Bot(token, 190)
bot191 = Bot(token, 191)
bot192 = Bot(token, 192)
bot193 = Bot(token, 193)
bot194 = Bot(token, 194)
bot195 = Bot(token, 195)
bot196 = Bot(token, 196)
bot197 = Bot(token, 197)
bot198 = Bot(token, 198)
bot199 = Bot(token, 199)
bot200 = Bot(token, 200)
bot201 = Bot(token, 201)
bot202 = Bot(token, 202)
bot203 = Bot(token, 203)
bot204 = Bot(token, 204)
bot205 = Bot(token, 205)
bot206 = Bot(token, 206)
bot207 = Bot(token, 207)
bot208 = Bot(token, 208)
bot209 = Bot(token, 209)
bot210 = Bot(token, 210)
bot211 = Bot(token, 211)
bot212 = Bot(token, 212)
bot213 = Bot(token, 213)
bot214 = Bot(token, 214)
bot215 = Bot(token, 215)
bot216 = Bot(token, 216)
bot217 = Bot(token, 217)
bot218 = Bot(token, 218)
bot219 = Bot(token, 219)
bot220 = Bot(token, 220)
bot221 = Bot(token, 221)
bot222 = Bot(token, 222)
bot223 = Bot(token, 223)
bot224 = Bot(token, 224)
bot225 = Bot(token, 225)
bot226 = Bot(token, 226)
bot227 = Bot(token, 227)
bot228 = Bot(token, 228)
bot229 = Bot(token, 229)
bot230 = Bot(token, 230)
bot231 = Bot(token, 231)
bot232 = Bot(token, 232)
bot233 = Bot(token, 233)
bot234 = Bot(token, 234)
bot235 = Bot(token, 235)
bot236 = Bot(token, 236)
bot237 = Bot(token, 237)
bot238 = Bot(token, 238)
bot239 = Bot(token, 239)
bot240 = Bot(token, 240)
bot241 = Bot(token, 241)
bot242 = Bot(token, 242)
bot243 = Bot(token, 243)
bot244 = Bot(token, 244)
bot245 = Bot(token, 245)
bot246 = Bot(token, 246)
bot247 = Bot(token, 247)
bot248 = Bot(token, 248)
bot249 = Bot(token, 249)
bot250 = Bot(token, 250)
bot251 = Bot(token, 251)
bot252 = Bot(token, 252)
bot253 = Bot(token, 253)
bot254 = Bot(token, 254)
bot255 = Bot(token, 255)
bot256 = Bot(token, 256)
bot257 = Bot(token, 257)
bot258 = Bot(token, 258)
bot259 = Bot(token, 259)
bot260 = Bot(token, 260)
bot261 = Bot(token, 261)
bot262 = Bot(token, 262)
bot263 = Bot(token, 263)
bot264 = Bot(token, 264)
bot265 = Bot(token, 265)
bot266 = Bot(token, 266)
bot267 = Bot(token, 267)
bot268 = Bot(token, 268)
bot269 = Bot(token, 269)
bot270 = Bot(token, 270)
bot271 = Bot(token, 271)
bot272 = Bot(token, 272)
bot273 = Bot(token, 273)
bot274 = Bot(token, 274)
bot275 = Bot(token, 275)
bot276 = Bot(token, 276)
bot277 = Bot(token, 277)
bot278 = Bot(token, 278)
bot279 = Bot(token, 279)
bot280 = Bot(token, 280)
bot281 = Bot(token, 281)
bot282 = Bot(token, 282)
bot283 = Bot(token, 283)
bot284 = Bot(token, 284)
bot285 = Bot(token, 285)
bot286 = Bot(token, 286)
bot287 = Bot(token, 287)
bot288 = Bot(token, 288)
bot289 = Bot(token, 289)
bot290 = Bot(token, 280)
bot291 = Bot(token, 291)
bot292 = Bot(token, 292)
bot293 = Bot(token, 293)
bot294 = Bot(token, 294)
bot295 = Bot(token, 295)
bot296 = Bot(token, 296)
bot297 = Bot(token, 297)
bot298 = Bot(token, 298)
bot299 = Bot(token, 299)
bot300 = Bot(token, 300)
bot301 = Bot(token, 301)
bot302 = Bot(token, 302)
bot303 = Bot(token, 303)
bot304 = Bot(token, 304)
bot305 = Bot(token, 305)
bot306 = Bot(token, 306)
bot307 = Bot(token, 307)
bot308 = Bot(token, 308)
bot309 = Bot(token, 309)
bot310 = Bot(token, 310)
bot311 = Bot(token, 311)
bot312 = Bot(token, 312)
bot313 = Bot(token, 313)
bot314 = Bot(token, 314)
bot315 = Bot(token, 315)
bot316 = Bot(token, 316)
bot317 = Bot(token, 317)
bot318 = Bot(token, 318)
bot319 = Bot(token, 319)
bot320 = Bot(token, 320)
bot321 = Bot(token, 321)
bot322 = Bot(token, 322)
bot323 = Bot(token, 223)
bot324 = Bot(token, 324)
bot325 = Bot(token, 325)
bot326 = Bot(token, 326)
bot327 = Bot(token, 327)
bot328 = Bot(token, 328)
bot329 = Bot(token, 329)
bot330 = Bot(token, 330)
bot331 = Bot(token, 331)
bot332 = Bot(token, 332)
bot333 = Bot(token, 333)
bot334 = Bot(token, 334)
bot335 = Bot(token, 335)
bot336 = Bot(token, 336)
bot337 = Bot(token, 337)
bot338 = Bot(token, 338)
bot339 = Bot(token, 339)
bot340 = Bot(token, 330)
bot341 = Bot(token, 341)
bot342 = Bot(token, 342)
bot343 = Bot(token, 343)
bot344 = Bot(token, 344)
bot345 = Bot(token, 345)
bot346 = Bot(token, 346)
bot347 = Bot(token, 347)
bot348 = Bot(token, 348)
bot349 = Bot(token, 349)
bot350 = Bot(token, 350)
bot351 = Bot(token, 351)
bot352 = Bot(token, 352)
bot353 = Bot(token, 353)
bot354 = Bot(token, 354)
bot355 = Bot(token, 355)
bot356 = Bot(token, 356)
bot357 = Bot(token, 357)
bot358 = Bot(token, 358)
bot359 = Bot(token, 359)
bot360 = Bot(token, 360)
bot361 = Bot(token, 361)
bot362 = Bot(token, 362)
bot363 = Bot(token, 363)
bot364 = Bot(token, 364)
bot365 = Bot(token, 365)
bot366 = Bot(token, 366)
bot367 = Bot(token, 367)
bot368 = Bot(token, 368)
bot369 = Bot(token, 369)
bot370 = Bot(token, 370)
bot371 = Bot(token, 371)
bot372 = Bot(token, 372)
bot373 = Bot(token, 273)
bot374 = Bot(token, 374)
bot375 = Bot(token, 375)
bot376 = Bot(token, 376)
bot377 = Bot(token, 377)
bot378 = Bot(token, 378)
bot379 = Bot(token, 379)
bot380 = Bot(token, 380)
bot381 = Bot(token, 381)
bot382 = Bot(token, 382)
bot383 = Bot(token, 383)
bot384 = Bot(token, 384)
bot385 = Bot(token, 385)
bot386 = Bot(token, 386)
bot387 = Bot(token, 387)
bot388 = Bot(token, 388)
bot389 = Bot(token, 389)
bot390 = Bot(token, 380)
bot391 = Bot(token, 391)
bot392 = Bot(token, 392)
bot393 = Bot(token, 393)
bot394 = Bot(token, 394)
bot395 = Bot(token, 395)
bot396 = Bot(token, 396)
bot397 = Bot(token, 397)
bot398 = Bot(token, 398)
bot399 = Bot(token, 399)
bot400 = Bot(token, 400)
bot401 = Bot(token, 401)
bot402 = Bot(token, 402)
bot403 = Bot(token, 403)
bot404 = Bot(token, 404)
bot405 = Bot(token, 405)
bot406 = Bot(token, 406)
bot407 = Bot(token, 407)
bot408 = Bot(token, 408)
bot409 = Bot(token, 409)
bot410 = Bot(token, 410)
bot411 = Bot(token, 411)
bot412 = Bot(token, 412)
bot413 = Bot(token, 413)
bot414 = Bot(token, 414)
bot415 = Bot(token, 415)
bot416 = Bot(token, 416)
bot417 = Bot(token, 417)
bot418 = Bot(token, 418)
bot419 = Bot(token, 419)
bot420 = Bot(token, 420)
bot421 = Bot(token, 421)
bot422 = Bot(token, 422)
bot423 = Bot(token, 423)
bot424 = Bot(token, 424)
bot425 = Bot(token, 425)
bot426 = Bot(token, 426)
bot427 = Bot(token, 427)
bot428 = Bot(token, 428)
bot429 = Bot(token, 429)
bot430 = Bot(token, 430)
bot431 = Bot(token, 431)
bot432 = Bot(token, 432)
bot433 = Bot(token, 433)
bot434 = Bot(token, 434)
bot435 = Bot(token, 435)
bot436 = Bot(token, 436)
bot437 = Bot(token, 437)
bot438 = Bot(token, 438)
bot439 = Bot(token, 439)
bot440 = Bot(token, 430)
bot441 = Bot(token, 441)
bot442 = Bot(token, 442)
bot443 = Bot(token, 443)
bot444 = Bot(token, 444)
bot445 = Bot(token, 445)
bot446 = Bot(token, 446)
bot447 = Bot(token, 447)
bot448 = Bot(token, 448)
bot449 = Bot(token, 449)
bot450 = Bot(token, 450)
bot451 = Bot(token, 451)
bot452 = Bot(token, 452)
bot453 = Bot(token, 453)
bot454 = Bot(token, 454)
bot455 = Bot(token, 455)
bot456 = Bot(token, 456)
bot457 = Bot(token, 457)
bot458 = Bot(token, 458)
bot459 = Bot(token, 459)
bot460 = Bot(token, 460)
bot461 = Bot(token, 461)
bot462 = Bot(token, 462)
bot463 = Bot(token, 463)
bot464 = Bot(token, 464)
bot465 = Bot(token, 465)
bot466 = Bot(token, 466)
bot467 = Bot(token, 467)
bot468 = Bot(token, 468)
bot469 = Bot(token, 469)
bot470 = Bot(token, 470)
bot471 = Bot(token, 471)
bot472 = Bot(token, 472)
bot473 = Bot(token, 473)
bot474 = Bot(token, 474)
bot475 = Bot(token, 475)
bot476 = Bot(token, 476)
bot477 = Bot(token, 477)
bot478 = Bot(token, 478)
bot479 = Bot(token, 479)
bot480 = Bot(token, 480)
bot481 = Bot(token, 481)
bot482 = Bot(token, 482)
bot483 = Bot(token, 483)
bot484 = Bot(token, 484)
bot485 = Bot(token, 485)
bot486 = Bot(token, 486)
bot487 = Bot(token, 487)
bot488 = Bot(token, 488)
bot489 = Bot(token, 489)
bot490 = Bot(token, 490)
bot491 = Bot(token, 491)
bot492 = Bot(token, 492)
bot493 = Bot(token, 493)
bot494 = Bot(token, 494)
bot495 = Bot(token, 495)
bot496 = Bot(token, 496)
bot497 = Bot(token, 497)
bot498 = Bot(token, 498)
bot499 = Bot(token, 499)
bot500 = Bot(token, 500)
bot501 = Bot(token, 501)
bot502 = Bot(token, 502)
bot503 = Bot(token, 503)
bot504 = Bot(token, 504)
bot505 = Bot(token, 505)
bot506 = Bot(token, 506)
bot507 = Bot(token, 507)
bot508 = Bot(token, 508)
bot509 = Bot(token, 509)
bot510 = Bot(token, 510)
bot511 = Bot(token, 511)
bot512 = Bot(token, 512)
bot513 = Bot(token, 513)
bot514 = Bot(token, 514)
bot515 = Bot(token, 515)
bot516 = Bot(token, 516)
bot517 = Bot(token, 517)
bot518 = Bot(token, 518)
bot519 = Bot(token, 519)
bot520 = Bot(token, 520)
bot521 = Bot(token, 521)
bot522 = Bot(token, 522)
bot523 = Bot(token, 523)
bot524 = Bot(token, 524)
bot525 = Bot(token, 525)
bot526 = Bot(token, 526)
bot527 = Bot(token, 527)
bot528 = Bot(token, 528)
bot529 = Bot(token, 529)
bot530 = Bot(token, 530)
bot531 = Bot(token, 531)
bot532 = Bot(token, 532)
bot533 = Bot(token, 533)
bot534 = Bot(token, 534)
bot535 = Bot(token, 535)
bot536 = Bot(token, 536)
bot537 = Bot(token, 537)
bot538 = Bot(token, 538)
bot539 = Bot(token, 539)
bot540 = Bot(token, 540)
bot541 = Bot(token, 541)
bot542 = Bot(token, 542)
bot543 = Bot(token, 543)
bot544 = Bot(token, 544)
bot545 = Bot(token, 545)
bot546 = Bot(token, 546)
bot547 = Bot(token, 547)
bot548 = Bot(token, 548)
bot549 = Bot(token, 549)
bot550 = Bot(token, 550)
bot551 = Bot(token, 551)
bot552 = Bot(token, 552)
bot553 = Bot(token, 553)
bot554 = Bot(token, 554)
bot555 = Bot(token, 555)
bot556 = Bot(token, 556)
bot557 = Bot(token, 557)
bot558 = Bot(token, 558)
bot559 = Bot(token, 559)
bot560 = Bot(token, 560)
bot561 = Bot(token, 561)
bot562 = Bot(token, 562)
bot563 = Bot(token, 563)
bot564 = Bot(token, 564)
bot565 = Bot(token, 565)
bot566 = Bot(token, 566)
bot567 = Bot(token, 567)
bot568 = Bot(token, 568)
bot569 = Bot(token, 569)
bot570 = Bot(token, 570)
bot571 = Bot(token, 571)
bot572 = Bot(token, 572)
bot573 = Bot(token, 573)
bot574 = Bot(token, 574)
bot575 = Bot(token, 575)
bot576 = Bot(token, 576)
bot577 = Bot(token, 577)
bot578 = Bot(token, 578)
bot579 = Bot(token, 579)
bot580 = Bot(token, 580)
bot581 = Bot(token, 581)
bot582 = Bot(token, 582)
bot583 = Bot(token, 583)
bot584 = Bot(token, 584)
bot585 = Bot(token, 585)
bot586 = Bot(token, 586)
bot587 = Bot(token, 587)
bot588 = Bot(token, 588)
bot589 = Bot(token, 589)
bot590 = Bot(token, 590)
bot591 = Bot(token, 591)
bot592 = Bot(token, 592)
bot593 = Bot(token, 593)
bot594 = Bot(token, 594)
bot595 = Bot(token, 595)
bot596 = Bot(token, 596)
bot597 = Bot(token, 597)
bot598 = Bot(token, 598)
bot599 = Bot(token, 599)
bot600 = Bot(token, 600)
bot601 = Bot(token, 601)
bot602 = Bot(token, 602)
bot603 = Bot(token, 603)
bot604 = Bot(token, 604)
bot605 = Bot(token, 605)
bot606 = Bot(token, 606)
bot607 = Bot(token, 607)
bot608 = Bot(token, 608)
bot609 = Bot(token, 609)
bot610 = Bot(token, 610)
bot611 = Bot(token, 611)
bot612 = Bot(token, 612)
bot613 = Bot(token, 613)
bot614 = Bot(token, 614)
bot615 = Bot(token, 615)
bot616 = Bot(token, 616)
bot617 = Bot(token, 617)
bot618 = Bot(token, 618)
bot619 = Bot(token, 619)
bot620 = Bot(token, 620)
bot621 = Bot(token, 621)
bot622 = Bot(token, 622)
bot623 = Bot(token, 623)
bot624 = Bot(token, 624)
bot625 = Bot(token, 625)
bot626 = Bot(token, 626)
bot627 = Bot(token, 627)
bot628 = Bot(token, 628)
bot629 = Bot(token, 629)
bot630 = Bot(token, 630)
bot631 = Bot(token, 631)
bot632 = Bot(token, 632)
bot633 = Bot(token, 633)
bot634 = Bot(token, 634)
bot635 = Bot(token, 635)
bot636 = Bot(token, 636)
bot637 = Bot(token, 637)
bot638 = Bot(token, 638)
bot639 = Bot(token, 639)
bot640 = Bot(token, 640)
bot641 = Bot(token, 641)
bot642 = Bot(token, 642)
bot643 = Bot(token, 643)
bot644 = Bot(token, 644)
bot645 = Bot(token, 645)
bot646 = Bot(token, 646)
bot647 = Bot(token, 647)
bot648 = Bot(token, 648)
bot649 = Bot(token, 649)
bot650 = Bot(token, 650)
bot651 = Bot(token, 651)
bot652 = Bot(token, 652)
bot653 = Bot(token, 653)
bot654 = Bot(token, 654)
bot655 = Bot(token, 655)
bot656 = Bot(token, 656)
bot657 = Bot(token, 657)
bot658 = Bot(token, 658)
bot659 = Bot(token, 659)
bot660 = Bot(token, 660)
bot661 = Bot(token, 661)
bot662 = Bot(token, 662)
bot663 = Bot(token, 663)
bot664 = Bot(token, 664)
bot665 = Bot(token, 665)
bot666 = Bot(token, 666)
bot667 = Bot(token, 667)
bot668 = Bot(token, 668)
bot669 = Bot(token, 669)
bot670 = Bot(token, 670)
bot671 = Bot(token, 671)
bot672 = Bot(token, 672)
bot673 = Bot(token, 673)
bot674 = Bot(token, 674)
bot675 = Bot(token, 675)
bot676 = Bot(token, 676)
bot677 = Bot(token, 677)
bot678 = Bot(token, 678)
bot679 = Bot(token, 679)
bot680 = Bot(token, 680)
bot681 = Bot(token, 681)
bot682 = Bot(token, 682)
bot683 = Bot(token, 683)
bot684 = Bot(token, 684)
bot685 = Bot(token, 685)
bot686 = Bot(token, 686)
bot687 = Bot(token, 687)
bot688 = Bot(token, 688)
bot689 = Bot(token, 689)
bot690 = Bot(token, 690)
bot691 = Bot(token, 691)
bot692 = Bot(token, 692)
bot693 = Bot(token, 693)
bot694 = Bot(token, 694)
bot695 = Bot(token, 695)
bot696 = Bot(token, 696)
bot697 = Bot(token, 697)
bot698 = Bot(token, 698)
bot699 = Bot(token, 699)
bot700 = Bot(token, 700)
bot701 = Bot(token, 701)
bot702 = Bot(token, 702)
bot703 = Bot(token, 703)
bot704 = Bot(token, 704)
bot705 = Bot(token, 705)
bot706 = Bot(token, 706)
bot707 = Bot(token, 707)
bot708 = Bot(token, 708)
bot709 = Bot(token, 709)
bot710 = Bot(token, 710)
bot711 = Bot(token, 711)
bot712 = Bot(token, 712)
bot713 = Bot(token, 713)
bot714 = Bot(token, 714)
bot715 = Bot(token, 715)
bot716 = Bot(token, 716)
bot717 = Bot(token, 717)
bot718 = Bot(token, 718)
bot719 = Bot(token, 719)
bot720 = Bot(token, 720)
bot721 = Bot(token, 721)
bot722 = Bot(token, 722)
bot723 = Bot(token, 723)
bot724 = Bot(token, 724)
bot725 = Bot(token, 795)
bot726 = Bot(token, 726)
bot727 = Bot(token, 727)
bot728 = Bot(token, 728)
bot729 = Bot(token, 729)
bot730 = Bot(token, 730)
bot731 = Bot(token, 731)
bot732 = Bot(token, 732)
bot733 = Bot(token, 733)
bot734 = Bot(token, 734)
bot735 = Bot(token, 735)
bot736 = Bot(token, 736)
bot737 = Bot(token, 737)
bot738 = Bot(token, 738)
bot739 = Bot(token, 739)
bot740 = Bot(token, 740)
bot741 = Bot(token, 741)
bot742 = Bot(token, 742)
bot743 = Bot(token, 743)
bot744 = Bot(token, 744)
bot745 = Bot(token, 745)
bot746 = Bot(token, 746)
bot747 = Bot(token, 747)
bot748 = Bot(token, 748)
bot749 = Bot(token, 749)
bot750 = Bot(token, 750)
bot751 = Bot(token, 751)
bot752 = Bot(token, 752)
bot753 = Bot(token, 753)
bot754 = Bot(token, 754)
bot755 = Bot(token, 755)
bot756 = Bot(token, 756)
bot757 = Bot(token, 757)
bot758 = Bot(token, 758)
bot759 = Bot(token, 759)
bot760 = Bot(token, 760)
bot761 = Bot(token, 761)
bot762 = Bot(token, 762)
bot763 = Bot(token, 763)
bot764 = Bot(token, 764)
bot765 = Bot(token, 765)
bot766 = Bot(token, 766)
bot767 = Bot(token, 767)
bot768 = Bot(token, 768)
bot769 = Bot(token, 769)
bot770 = Bot(token, 770)
bot771 = Bot(token, 771)
bot772 = Bot(token, 772)
bot773 = Bot(token, 773)
bot774 = Bot(token, 774)
bot775 = Bot(token, 775)
bot776 = Bot(token, 776)
bot777 = Bot(token, 777)
bot778 = Bot(token, 778)
bot779 = Bot(token, 779)
bot780 = Bot(token, 780)
bot781 = Bot(token, 781)
bot782 = Bot(token, 782)
bot783 = Bot(token, 783)
bot784 = Bot(token, 784)
bot785 = Bot(token, 785)
bot786 = Bot(token, 786)
bot787 = Bot(token, 787)
bot788 = Bot(token, 788)
bot789 = Bot(token, 789)
bot790 = Bot(token, 790)
bot791 = Bot(token, 791)
bot792 = Bot(token, 792)
bot793 = Bot(token, 793)
bot794 = Bot(token, 794)
bot795 = Bot(token, 795)
bot796 = Bot(token, 796)
bot797 = Bot(token, 797)
bot798 = Bot(token, 798)
bot799 = Bot(token, 799)
bot800 = Bot(token, 800)
bot801 = Bot(token, 801)
bot802 = Bot(token, 802)
bot803 = Bot(token, 803)
bot804 = Bot(token, 804)
bot805 = Bot(token, 805)
bot806 = Bot(token, 806)
bot807 = Bot(token, 807)
bot808 = Bot(token, 808)
bot809 = Bot(token, 809)
bot810 = Bot(token, 810)
bot811 = Bot(token, 811)
bot812 = Bot(token, 812)
bot813 = Bot(token, 813)
bot814 = Bot(token, 814)
bot815 = Bot(token, 815)
bot816 = Bot(token, 816)
bot817 = Bot(token, 817)
bot818 = Bot(token, 818)
bot819 = Bot(token, 819)
bot820 = Bot(token, 820)
bot821 = Bot(token, 821)
bot822 = Bot(token, 822)
bot823 = Bot(token, 823)
bot824 = Bot(token, 824)
bot825 = Bot(token, 825)
bot826 = Bot(token, 826)
bot827 = Bot(token, 827)
bot828 = Bot(token, 828)
bot829 = Bot(token, 829)
bot830 = Bot(token, 830)
bot831 = Bot(token, 831)
bot832 = Bot(token, 832)
bot833 = Bot(token, 833)
bot834 = Bot(token, 834)
bot835 = Bot(token, 835)
bot836 = Bot(token, 836)
bot837 = Bot(token, 837)
bot838 = Bot(token, 838)
bot839 = Bot(token, 839)
bot840 = Bot(token, 840)
bot841 = Bot(token, 841)
bot842 = Bot(token, 842)
bot843 = Bot(token, 843)
bot844 = Bot(token, 844)
bot845 = Bot(token, 845)
bot846 = Bot(token, 846)
bot847 = Bot(token, 847)
bot848 = Bot(token, 848)
bot849 = Bot(token, 849)
bot850 = Bot(token, 850)
bot851 = Bot(token, 851)
bot852 = Bot(token, 852)
bot853 = Bot(token, 853)
bot854 = Bot(token, 854)
bot855 = Bot(token, 855)
bot856 = Bot(token, 856)
bot857 = Bot(token, 857)
bot858 = Bot(token, 858)
bot859 = Bot(token, 859)
bot860 = Bot(token, 860)
bot861 = Bot(token, 861)
bot862 = Bot(token, 862)
bot863 = Bot(token, 863)
bot864 = Bot(token, 864)
bot865 = Bot(token, 865)
bot866 = Bot(token, 866)
bot867 = Bot(token, 867)
bot868 = Bot(token, 868)
bot869 = Bot(token, 869)
bot870 = Bot(token, 870)
bot871 = Bot(token, 871)
bot872 = Bot(token, 872)
bot873 = Bot(token, 873)
bot874 = Bot(token, 874)
bot875 = Bot(token, 875)
bot876 = Bot(token, 876)
bot877 = Bot(token, 877)
bot878 = Bot(token, 878)
bot879 = Bot(token, 879)
bot880 = Bot(token, 880)
bot881 = Bot(token, 881)
bot882 = Bot(token, 882)
bot883 = Bot(token, 883)
bot884 = Bot(token, 884)
bot885 = Bot(token, 885)
bot886 = Bot(token, 886)
bot887 = Bot(token, 887)
bot888 = Bot(token, 888)
bot889 = Bot(token, 889)
bot890 = Bot(token, 890)
bot891 = Bot(token, 891)
bot892 = Bot(token, 892)
bot893 = Bot(token, 893)
bot894 = Bot(token, 894)
bot895 = Bot(token, 895)
bot896 = Bot(token, 896)
bot897 = Bot(token, 897)
bot898 = Bot(token, 898)
bot899 = Bot(token, 899)
bot900 = Bot(token, 900)
bot901 = Bot(token, 901)
bot902 = Bot(token, 902)
bot903 = Bot(token, 903)
bot904 = Bot(token, 904)
bot905 = Bot(token, 905)
bot906 = Bot(token, 906)
bot907 = Bot(token, 907)
bot908 = Bot(token, 908)
bot909 = Bot(token, 909)
bot910 = Bot(token, 910)
bot911 = Bot(token, 911)
bot912 = Bot(token, 912)
bot913 = Bot(token, 913)
bot914 = Bot(token, 914)
bot915 = Bot(token, 915)
bot916 = Bot(token, 916)
bot917 = Bot(token, 917)
bot918 = Bot(token, 918)
bot919 = Bot(token, 919)
bot920 = Bot(token, 920)
bot921 = Bot(token, 921)
bot922 = Bot(token, 922)
bot923 = Bot(token, 923)
bot924 = Bot(token, 924)
bot925 = Bot(token, 925)
bot926 = Bot(token, 926)
bot927 = Bot(token, 927)
bot928 = Bot(token, 928)
bot929 = Bot(token, 929)
bot930 = Bot(token, 930)
bot931 = Bot(token, 931)
bot932 = Bot(token, 932)
bot933 = Bot(token, 933)
bot934 = Bot(token, 934)
bot935 = Bot(token, 935)
bot936 = Bot(token, 936)
bot937 = Bot(token, 937)
bot938 = Bot(token, 938)
bot939 = Bot(token, 939)
bot940 = Bot(token, 940)
bot941 = Bot(token, 941)
bot942 = Bot(token, 942)
bot943 = Bot(token, 943)
bot944 = Bot(token, 944)
bot945 = Bot(token, 945)
bot946 = Bot(token, 946)
bot947 = Bot(token, 947)
bot948 = Bot(token, 948)
bot949 = Bot(token, 949)
bot950 = Bot(token, 950)
bot951 = Bot(token, 951)
bot952 = Bot(token, 952)
bot953 = Bot(token, 953)
bot954 = Bot(token, 954)
bot955 = Bot(token, 955)
bot956 = Bot(token, 956)
bot957 = Bot(token, 957)
bot958 = Bot(token, 958)
bot959 = Bot(token, 959)
bot960 = Bot(token, 960)
bot961 = Bot(token, 961)
bot962 = Bot(token, 962)
bot963 = Bot(token, 963)
bot964 = Bot(token, 964)
bot965 = Bot(token, 965)
bot966 = Bot(token, 966)
bot967 = Bot(token, 967)
bot968 = Bot(token, 968)
bot969 = Bot(token, 969)
bot970 = Bot(token, 970)
bot971 = Bot(token, 971)
bot972 = Bot(token, 972)
bot973 = Bot(token, 973)
bot974 = Bot(token, 974)
bot975 = Bot(token, 975)
bot976 = Bot(token, 976)
bot977 = Bot(token, 977)
bot978 = Bot(token, 978)
bot979 = Bot(token, 979)
bot980 = Bot(token, 980)
bot981 = Bot(token, 981)
bot982 = Bot(token, 982)
bot983 = Bot(token, 983)
bot984 = Bot(token, 984)
bot985 = Bot(token, 985)
bot986 = Bot(token, 986)
bot987 = Bot(token, 987)
bot988 = Bot(token, 988)
bot989 = Bot(token, 989)
bot990 = Bot(token, 990)
bot991 = Bot(token, 991)
bot992 = Bot(token, 992)
bot993 = Bot(token, 993)
bot994 = Bot(token, 994)
bot995 = Bot(token, 995)
bot996 = Bot(token, 996)
bot997 = Bot(token, 997)
bot998 = Bot(token, 998)
bot999 = Bot(token, 999)


async def main():
    await asyncio.gather(
        bot0.start(),
        bot1.start(),
        bot2.start(),
        bot3.start(),
        bot4.start(),
        bot5.start(),
        bot6.start(),
        bot7.start(),
        bot8.start(),
        bot9.start(),
        bot10.start(),
        bot11.start(),
        bot12.start(),
        bot13.start(),
        bot14.start(),
        bot15.start(),
        bot16.start(),
        bot17.start(),
        bot18.start(),
        bot19.start(),
        bot20.start(),
        bot21.start(),
        bot22.start(),
        bot23.start(),
        bot24.start(),
        bot25.start(),
        bot26.start(),
        bot27.start(),
        bot28.start(),
        bot29.start(),
        bot30.start(),
        bot31.start(),
        bot32.start(),
        bot33.start(),
        bot34.start(),
        bot35.start(),
        bot36.start(),
        bot37.start(),
        bot38.start(),
        bot39.start(),
        bot40.start(),
        bot41.start(),
        bot42.start(),
        bot43.start(),
        bot44.start(),
        bot45.start(),
        bot46.start(),
        bot47.start(),
        bot48.start(),
        bot49.start(),
        bot50.start(),
        bot51.start(),
        bot52.start(),
        bot53.start(),
        bot54.start(),
        bot55.start(),
        bot56.start(),
        bot57.start(),
        bot58.start(),
        bot59.start(),
        bot60.start(),
        bot61.start(),
        bot62.start(),
        bot63.start(),
        bot64.start(),
        bot65.start(),
        bot66.start(),
        bot67.start(),
        bot68.start(),
        bot69.start(),
        bot70.start(),
        bot71.start(),
        bot72.start(),
        bot73.start(),
        bot74.start(),
        bot75.start(),
        bot76.start(),
        bot77.start(),
        bot78.start(),
        bot79.start(),
        bot80.start(),
        bot81.start(),
        bot82.start(),
        bot83.start(),
        bot84.start(),
        bot85.start(),
        bot86.start(),
        bot87.start(),
        bot88.start(),
        bot89.start(),
        bot90.start(),
        bot91.start(),
        bot92.start(),
        bot93.start(),
        bot94.start(),
        bot95.start(),
        bot96.start(),
        bot97.start(),
        bot98.start(),
        bot99.start(),
        bot100.start(),
        bot101.start(),
        bot102.start(),
        bot103.start(),
        bot104.start(),
        bot105.start(),
        bot106.start(),
        bot107.start(),
        bot108.start(),
        bot109.start(),
        bot110.start(),
        bot111.start(),
        bot112.start(),
        bot113.start(),
        bot114.start(),
        bot115.start(),
        bot116.start(),
        bot117.start(),
        bot118.start(),
        bot119.start(),
        bot120.start(),
        bot121.start(),
        bot122.start(),
        bot123.start(),
        bot124.start(),
        bot125.start(),
        bot126.start(),
        bot127.start(),
        bot128.start(),
        bot129.start(),
        bot130.start(),
        bot131.start(),
        bot132.start(),
        bot133.start(),
        bot134.start(),
        bot135.start(),
        bot136.start(),
        bot137.start(),
        bot138.start(),
        bot139.start(),
        bot140.start(),
        bot141.start(),
        bot142.start(),
        bot143.start(),
        bot144.start(),
        bot145.start(),
        bot146.start(),
        bot147.start(),
        bot148.start(),
        bot149.start(),
        bot150.start(),
        bot151.start(),
        bot152.start(),
        bot153.start(),
        bot154.start(),
        bot155.start(),
        bot156.start(),
        bot157.start(),
        bot158.start(),
        bot159.start(),
        bot160.start(),
        bot161.start(),
        bot162.start(),
        bot163.start(),
        bot164.start(),
        bot165.start(),
        bot166.start(),
        bot167.start(),
        bot168.start(),
        bot169.start(),
        bot170.start(),
        bot171.start(),
        bot172.start(),
        bot173.start(),
        bot174.start(),
        bot175.start(),
        bot176.start(),
        bot177.start(),
        bot178.start(),
        bot179.start(),
        bot180.start(),
        bot181.start(),
        bot182.start(),
        bot183.start(),
        bot184.start(),
        bot185.start(),
        bot186.start(),
        bot187.start(),
        bot188.start(),
        bot189.start(),
        bot190.start(),
        bot191.start(),
        bot192.start(),
        bot193.start(),
        bot194.start(),
        bot195.start(),
        bot196.start(),
        bot197.start(),
        bot198.start(),
        bot199.start(),
        bot200.start(),
        bot201.start(),
        bot202.start(),
        bot203.start(),
        bot204.start(),
        bot205.start(),
        bot206.start(),
        bot207.start(),
        bot208.start(),
        bot209.start(),
        bot210.start(),
        bot211.start(),
        bot212.start(),
        bot213.start(),
        bot214.start(),
        bot215.start(),
        bot216.start(),
        bot217.start(),
        bot218.start(),
        bot219.start(),
        bot220.start(),
        bot221.start(),
        bot222.start(),
        bot223.start(),
        bot224.start(),
        bot225.start(),
        bot226.start(),
        bot227.start(),
        bot228.start(),
        bot229.start(),
        bot230.start(),
        bot231.start(),
        bot232.start(),
        bot233.start(),
        bot234.start(),
        bot235.start(),
        bot236.start(),
        bot237.start(),
        bot238.start(),
        bot239.start(),
        bot240.start(),
        bot241.start(),
        bot242.start(),
        bot243.start(),
        bot244.start(),
        bot245.start(),
        bot246.start(),
        bot247.start(),
        bot248.start(),
        bot249.start(),
        bot250.start(),
        bot251.start(),
        bot252.start(),
        bot253.start(),
        bot254.start(),
        bot255.start(),
        bot256.start(),
        bot257.start(),
        bot258.start(),
        bot259.start(),
        bot260.start(),
        bot261.start(),
        bot262.start(),
        bot263.start(),
        bot264.start(),
        bot265.start(),
        bot266.start(),
        bot267.start(),
        bot268.start(),
        bot269.start(),
        bot270.start(),
        bot271.start(),
        bot272.start(),
        bot273.start(),
        bot274.start(),
        bot275.start(),
        bot276.start(),
        bot277.start(),
        bot278.start(),
        bot279.start(),
        bot280.start(),
        bot281.start(),
        bot282.start(),
        bot283.start(),
        bot284.start(),
        bot285.start(),
        bot286.start(),
        bot287.start(),
        bot288.start(),
        bot289.start(),
        bot290.start(),
        bot291.start(),
        bot292.start(),
        bot293.start(),
        bot294.start(),
        bot295.start(),
        bot296.start(),
        bot297.start(),
        bot298.start(),
        bot299.start(),
        bot300.start(),
        bot301.start(),
        bot302.start(),
        bot303.start(),
        bot304.start(),
        bot305.start(),
        bot306.start(),
        bot307.start(),
        bot308.start(),
        bot309.start(),
        bot310.start(),
        bot311.start(),
        bot312.start(),
        bot313.start(),
        bot314.start(),
        bot315.start(),
        bot316.start(),
        bot317.start(),
        bot318.start(),
        bot319.start(),
        bot320.start(),
        bot321.start(),
        bot322.start(),
        bot323.start(),
        bot324.start(),
        bot325.start(),
        bot326.start(),
        bot327.start(),
        bot328.start(),
        bot329.start(),
        bot330.start(),
        bot331.start(),
        bot332.start(),
        bot333.start(),
        bot334.start(),
        bot335.start(),
        bot336.start(),
        bot337.start(),
        bot338.start(),
        bot339.start(),
        bot340.start(),
        bot341.start(),
        bot342.start(),
        bot343.start(),
        bot344.start(),
        bot345.start(),
        bot346.start(),
        bot347.start(),
        bot348.start(),
        bot349.start(),
        bot350.start(),
        bot351.start(),
        bot352.start(),
        bot353.start(),
        bot354.start(),
        bot355.start(),
        bot356.start(),
        bot357.start(),
        bot358.start(),
        bot359.start(),
        bot360.start(),
        bot361.start(),
        bot362.start(),
        bot363.start(),
        bot364.start(),
        bot365.start(),
        bot366.start(),
        bot367.start(),
        bot368.start(),
        bot369.start(),
        bot370.start(),
        bot371.start(),
        bot372.start(),
        bot373.start(),
        bot374.start(),
        bot375.start(),
        bot376.start(),
        bot377.start(),
        bot378.start(),
        bot379.start(),
        bot380.start(),
        bot381.start(),
        bot382.start(),
        bot383.start(),
        bot384.start(),
        bot385.start(),
        bot386.start(),
        bot387.start(),
        bot388.start(),
        bot389.start(),
        bot390.start(),
        bot391.start(),
        bot392.start(),
        bot393.start(),
        bot394.start(),
        bot395.start(),
        bot396.start(),
        bot397.start(),
        bot398.start(),
        bot399.start(),
        bot400.start(),
        bot401.start(),
        bot402.start(),
        bot403.start(),
        bot404.start(),
        bot405.start(),
        bot406.start(),
        bot407.start(),
        bot408.start(),
        bot409.start(),
        bot410.start(),
        bot411.start(),
        bot412.start(),
        bot413.start(),
        bot414.start(),
        bot415.start(),
        bot416.start(),
        bot417.start(),
        bot418.start(),
        bot419.start(),
        bot420.start(),
        bot421.start(),
        bot422.start(),
        bot423.start(),
        bot424.start(),
        bot425.start(),
        bot426.start(),
        bot427.start(),
        bot428.start(),
        bot429.start(),
        bot430.start(),
        bot431.start(),
        bot432.start(),
        bot433.start(),
        bot434.start(),
        bot435.start(),
        bot436.start(),
        bot437.start(),
        bot438.start(),
        bot439.start(),
        bot440.start(),
        bot441.start(),
        bot442.start(),
        bot443.start(),
        bot444.start(),
        bot445.start(),
        bot446.start(),
        bot447.start(),
        bot448.start(),
        bot449.start(),
        bot450.start(),
        bot451.start(),
        bot452.start(),
        bot453.start(),
        bot454.start(),
        bot455.start(),
        bot456.start(),
        bot457.start(),
        bot458.start(),
        bot459.start(),
        bot460.start(),
        bot461.start(),
        bot462.start(),
        bot463.start(),
        bot464.start(),
        bot465.start(),
        bot466.start(),
        bot467.start(),
        bot468.start(),
        bot469.start(),
        bot470.start(),
        bot471.start(),
        bot472.start(),
        bot473.start(),
        bot474.start(),
        bot475.start(),
        bot476.start(),
        bot477.start(),
        bot478.start(),
        bot479.start(),
        bot480.start(),
        bot481.start(),
        bot482.start(),
        bot483.start(),
        bot484.start(),
        bot485.start(),
        bot486.start(),
        bot487.start(),
        bot488.start(),
        bot489.start(),
        bot490.start(),
        bot491.start(),
        bot492.start(),
        bot493.start(),
        bot494.start(),
        bot495.start(),
        bot496.start(),
        bot497.start(),
        bot498.start(),
        bot499.start(),
        bot500.start(),
        bot501.start(),
        bot502.start(),
        bot503.start(),
        bot504.start(),
        bot505.start(),
        bot506.start(),
        bot507.start(),
        bot508.start(),
        bot509.start(),
        bot510.start(),
        bot511.start(),
        bot512.start(),
        bot513.start(),
        bot514.start(),
        bot515.start(),
        bot516.start(),
        bot517.start(),
        bot518.start(),
        bot519.start(),
        bot520.start(),
        bot521.start(),
        bot522.start(),
        bot523.start(),
        bot524.start(),
        bot525.start(),
        bot526.start(),
        bot527.start(),
        bot528.start(),
        bot529.start(),
        bot530.start(),
        bot531.start(),
        bot532.start(),
        bot533.start(),
        bot534.start(),
        bot535.start(),
        bot536.start(),
        bot537.start(),
        bot538.start(),
        bot539.start(),
        bot540.start(),
        bot541.start(),
        bot542.start(),
        bot543.start(),
        bot544.start(),
        bot545.start(),
        bot546.start(),
        bot547.start(),
        bot548.start(),
        bot549.start(),
        bot550.start(),
        bot551.start(),
        bot552.start(),
        bot553.start(),
        bot554.start(),
        bot555.start(),
        bot556.start(),
        bot557.start(),
        bot558.start(),
        bot559.start(),
        bot560.start(),
        bot561.start(),
        bot562.start(),
        bot563.start(),
        bot564.start(),
        bot565.start(),
        bot566.start(),
        bot567.start(),
        bot568.start(),
        bot569.start(),
        bot570.start(),
        bot571.start(),
        bot572.start(),
        bot573.start(),
        bot574.start(),
        bot575.start(),
        bot576.start(),
        bot577.start(),
        bot578.start(),
        bot579.start(),
        bot580.start(),
        bot581.start(),
        bot582.start(),
        bot583.start(),
        bot584.start(),
        bot585.start(),
        bot586.start(),
        bot587.start(),
        bot588.start(),
        bot589.start(),
        bot590.start(),
        bot591.start(),
        bot592.start(),
        bot593.start(),
        bot594.start(),
        bot595.start(),
        bot596.start(),
        bot597.start(),
        bot598.start(),
        bot599.start(),
        bot600.start(),
        bot601.start(),
        bot602.start(),
        bot603.start(),
        bot604.start(),
        bot605.start(),
        bot606.start(),
        bot607.start(),
        bot608.start(),
        bot609.start(),
        bot610.start(),
        bot611.start(),
        bot612.start(),
        bot613.start(),
        bot614.start(),
        bot615.start(),
        bot616.start(),
        bot617.start(),
        bot618.start(),
        bot619.start(),
        bot620.start(),
        bot621.start(),
        bot622.start(),
        bot623.start(),
        bot624.start(),
        bot625.start(),
        bot626.start(),
        bot627.start(),
        bot628.start(),
        bot629.start(),
        bot630.start(),
        bot631.start(),
        bot632.start(),
        bot633.start(),
        bot634.start(),
        bot635.start(),
        bot636.start(),
        bot637.start(),
        bot638.start(),
        bot639.start(),
        bot640.start(),
        bot641.start(),
        bot642.start(),
        bot643.start(),
        bot644.start(),
        bot645.start(),
        bot646.start(),
        bot647.start(),
        bot648.start(),
        bot649.start(),
        bot650.start(),
        bot651.start(),
        bot652.start(),
        bot653.start(),
        bot654.start(),
        bot655.start(),
        bot656.start(),
        bot657.start(),
        bot658.start(),
        bot659.start(),
        bot660.start(),
        bot661.start(),
        bot662.start(),
        bot663.start(),
        bot664.start(),
        bot665.start(),
        bot666.start(),
        bot667.start(),
        bot668.start(),
        bot669.start(),
        bot670.start(),
        bot671.start(),
        bot672.start(),
        bot673.start(),
        bot674.start(),
        bot675.start(),
        bot676.start(),
        bot677.start(),
        bot678.start(),
        bot679.start(),
        bot680.start(),
        bot681.start(),
        bot682.start(),
        bot683.start(),
        bot684.start(),
        bot685.start(),
        bot686.start(),
        bot687.start(),
        bot688.start(),
        bot689.start(),
        bot690.start(),
        bot691.start(),
        bot692.start(),
        bot693.start(),
        bot694.start(),
        bot695.start(),
        bot696.start(),
        bot697.start(),
        bot698.start(),
        bot699.start(),
        bot700.start(),
        bot701.start(),
        bot702.start(),
        bot703.start(),
        bot704.start(),
        bot705.start(),
        bot706.start(),
        bot707.start(),
        bot708.start(),
        bot709.start(),
        bot710.start(),
        bot711.start(),
        bot712.start(),
        bot713.start(),
        bot714.start(),
        bot715.start(),
        bot716.start(),
        bot717.start(),
        bot718.start(),
        bot719.start(),
        bot720.start(),
        bot721.start(),
        bot722.start(),
        bot723.start(),
        bot724.start(),
        bot725.start(),
        bot726.start(),
        bot727.start(),
        bot728.start(),
        bot729.start(),
        bot730.start(),
        bot731.start(),
        bot732.start(),
        bot733.start(),
        bot734.start(),
        bot735.start(),
        bot736.start(),
        bot737.start(),
        bot738.start(),
        bot739.start(),
        bot740.start(),
        bot741.start(),
        bot742.start(),
        bot743.start(),
        bot744.start(),
        bot745.start(),
        bot746.start(),
        bot747.start(),
        bot748.start(),
        bot749.start(),
        bot750.start(),
        bot751.start(),
        bot752.start(),
        bot753.start(),
        bot754.start(),
        bot755.start(),
        bot756.start(),
        bot757.start(),
        bot758.start(),
        bot759.start(),
        bot760.start(),
        bot761.start(),
        bot762.start(),
        bot763.start(),
        bot764.start(),
        bot765.start(),
        bot766.start(),
        bot767.start(),
        bot768.start(),
        bot769.start(),
        bot770.start(),
        bot771.start(),
        bot772.start(),
        bot773.start(),
        bot774.start(),
        bot775.start(),
        bot776.start(),
        bot777.start(),
        bot778.start(),
        bot779.start(),
        bot780.start(),
        bot781.start(),
        bot782.start(),
        bot783.start(),
        bot784.start(),
        bot785.start(),
        bot786.start(),
        bot787.start(),
        bot788.start(),
        bot789.start(),
        bot790.start(),
        bot791.start(),
        bot792.start(),
        bot793.start(),
        bot794.start(),
        bot795.start(),
        bot796.start(),
        bot797.start(),
        bot798.start(),
        bot799.start(),
        bot800.start(),
        bot801.start(),
        bot802.start(),
        bot803.start(),
        bot804.start(),
        bot805.start(),
        bot806.start(),
        bot807.start(),
        bot808.start(),
        bot809.start(),
        bot810.start(),
        bot811.start(),
        bot812.start(),
        bot813.start(),
        bot814.start(),
        bot815.start(),
        bot816.start(),
        bot817.start(),
        bot818.start(),
        bot819.start(),
        bot820.start(),
        bot821.start(),
        bot822.start(),
        bot823.start(),
        bot824.start(),
        bot825.start(),
        bot826.start(),
        bot827.start(),
        bot828.start(),
        bot829.start(),
        bot830.start(),
        bot831.start(),
        bot832.start(),
        bot833.start(),
        bot834.start(),
        bot835.start(),
        bot836.start(),
        bot837.start(),
        bot838.start(),
        bot839.start(),
        bot840.start(),
        bot841.start(),
        bot842.start(),
        bot843.start(),
        bot844.start(),
        bot845.start(),
        bot846.start(),
        bot847.start(),
        bot848.start(),
        bot849.start(),
        bot850.start(),
        bot851.start(),
        bot852.start(),
        bot853.start(),
        bot854.start(),
        bot855.start(),
        bot856.start(),
        bot857.start(),
        bot858.start(),
        bot859.start(),
        bot860.start(),
        bot861.start(),
        bot862.start(),
        bot863.start(),
        bot864.start(),
        bot865.start(),
        bot866.start(),
        bot867.start(),
        bot868.start(),
        bot869.start(),
        bot870.start(),
        bot871.start(),
        bot872.start(),
        bot873.start(),
        bot874.start(),
        bot875.start(),
        bot876.start(),
        bot877.start(),
        bot878.start(),
        bot879.start(),
        bot880.start(),
        bot881.start(),
        bot882.start(),
        bot883.start(),
        bot884.start(),
        bot885.start(),
        bot886.start(),
        bot887.start(),
        bot888.start(),
        bot889.start(),
        bot890.start(),
        bot891.start(),
        bot892.start(),
        bot893.start(),
        bot894.start(),
        bot895.start(),
        bot896.start(),
        bot897.start(),
        bot898.start(),
        bot899.start(),
        bot900.start(),
        bot901.start(),
        bot902.start(),
        bot903.start(),
        bot904.start(),
        bot905.start(),
        bot906.start(),
        bot907.start(),
        bot908.start(),
        bot909.start(),
        bot910.start(),
        bot911.start(),
        bot912.start(),
        bot913.start(),
        bot914.start(),
        bot915.start(),
        bot916.start(),
        bot917.start(),
        bot918.start(),
        bot919.start(),
        bot920.start(),
        bot921.start(),
        bot922.start(),
        bot923.start(),
        bot924.start(),
        bot925.start(),
        bot926.start(),
        bot927.start(),
        bot928.start(),
        bot929.start(),
        bot930.start(),
        bot931.start(),
        bot932.start(),
        bot933.start(),
        bot934.start(),
        bot935.start(),
        bot936.start(),
        bot937.start(),
        bot938.start(),
        bot939.start(),
        bot940.start(),
        bot941.start(),
        bot942.start(),
        bot943.start(),
        bot944.start(),
        bot945.start(),
        bot946.start(),
        bot947.start(),
        bot948.start(),
        bot949.start(),
        bot950.start(),
        bot951.start(),
        bot952.start(),
        bot953.start(),
        bot954.start(),
        bot955.start(),
        bot956.start(),
        bot957.start(),
        bot958.start(),
        bot959.start(),
        bot960.start(),
        bot961.start(),
        bot962.start(),
        bot963.start(),
        bot964.start(),
        bot965.start(),
        bot966.start(),
        bot967.start(),
        bot968.start(),
        bot969.start(),
        bot970.start(),
        bot971.start(),
        bot972.start(),
        bot973.start(),
        bot974.start(),
        bot975.start(),
        bot976.start(),
        bot977.start(),
        bot978.start(),
        bot979.start(),
        bot980.start(),
        bot981.start(),
        bot982.start(),
        bot983.start(),
        bot984.start(),
        bot985.start(),
        bot986.start(),
        bot987.start(),
        bot988.start(),
        bot989.start(),
        bot990.start(),
        bot991.start(),
        bot992.start(),
        bot993.start(),
        bot994.start(),
        bot995.start(),
        bot996.start(),
        bot997.start(),
        bot998.start(),
        bot999.start()
        )


asyncio.run(main())
