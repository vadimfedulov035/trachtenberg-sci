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
                    self.m3 = "/s10, /s15, /s20, /s25, /s50, /s[number])"
                elif self.lang == "ru":
                    self.m1 = "Как много итераций прежде чем "
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
                if self.lang == "en":
                    self.m = "No changes to init mode were made!"
                elif self.lang == "ru":
                    self.m = "Никаких изменений!"
                try:  # check for continue command
                    await self.sndm(self.m)
                except ConnectionError:
                    continue
                self.diffch = False
                break
            if not self.mc4:
                if self.lang == "en":
                    self.m1 = "What initial difficulty do you want? 0 - is "
                    self.m2 = "default and d options are next steps (/0, "
                    self.m3 = "/d2, /d3, /d4, /d5, /d6, /d7, /d8, /d[number])"
                elif self.lang == "ru":
                    self.m1 = "Какую стартовую сложность вы хотите? 0 - это "
                    self.m2 = "обычная и d опции следующие шаги (/0, "
                    self.m3 = "/d2, /d3, /d4, /d5, /d6, /d7, /d8, /d[число])"
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
                if self.rdlm != self.prevm and self.rdlm != "/0" and self.rdlm != "/start":
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
pbot500 = Bot(token, 500)
pbot501 = Bot(token, 501)
pbot502 = Bot(token, 502)
pbot503 = Bot(token, 503)
pbot504 = Bot(token, 504)
pbot505 = Bot(token, 505)
pbot506 = Bot(token, 506)
pbot507 = Bot(token, 507)
pbot508 = Bot(token, 508)
pbot509 = Bot(token, 509)
pbot510 = Bot(token, 510)
pbot511 = Bot(token, 511)
pbot512 = Bot(token, 512)
pbot513 = Bot(token, 513)
pbot514 = Bot(token, 514)
pbot515 = Bot(token, 515)
pbot516 = Bot(token, 516)
pbot517 = Bot(token, 517)
pbot518 = Bot(token, 518)
pbot519 = Bot(token, 519)
pbot520 = Bot(token, 520)
pbot521 = Bot(token, 521)
pbot522 = Bot(token, 522)
pbot523 = Bot(token, 523)
pbot524 = Bot(token, 524)
pbot525 = Bot(token, 525)
pbot526 = Bot(token, 526)
pbot527 = Bot(token, 527)
pbot528 = Bot(token, 528)
pbot529 = Bot(token, 529)
pbot530 = Bot(token, 530)
pbot531 = Bot(token, 531)
pbot532 = Bot(token, 532)
pbot533 = Bot(token, 533)
pbot534 = Bot(token, 534)
pbot535 = Bot(token, 535)
pbot536 = Bot(token, 536)
pbot537 = Bot(token, 537)
pbot538 = Bot(token, 538)
pbot539 = Bot(token, 539)
pbot540 = Bot(token, 540)
pbot541 = Bot(token, 541)
pbot542 = Bot(token, 542)
pbot543 = Bot(token, 543)
pbot544 = Bot(token, 544)
pbot545 = Bot(token, 545)
pbot546 = Bot(token, 546)
pbot547 = Bot(token, 547)
pbot548 = Bot(token, 548)
pbot549 = Bot(token, 549)
pbot550 = Bot(token, 550)
pbot551 = Bot(token, 551)
pbot552 = Bot(token, 552)
pbot553 = Bot(token, 553)
pbot554 = Bot(token, 554)
pbot555 = Bot(token, 555)
pbot556 = Bot(token, 556)
pbot557 = Bot(token, 557)
pbot558 = Bot(token, 558)
pbot559 = Bot(token, 559)
pbot560 = Bot(token, 560)
pbot561 = Bot(token, 561)
pbot562 = Bot(token, 562)
pbot563 = Bot(token, 563)
pbot564 = Bot(token, 564)
pbot565 = Bot(token, 565)
pbot566 = Bot(token, 566)
pbot567 = Bot(token, 567)
pbot568 = Bot(token, 568)
pbot569 = Bot(token, 569)
pbot570 = Bot(token, 570)
pbot571 = Bot(token, 571)
pbot572 = Bot(token, 572)
pbot573 = Bot(token, 573)
pbot574 = Bot(token, 574)
pbot575 = Bot(token, 575)
pbot576 = Bot(token, 576)
pbot577 = Bot(token, 577)
pbot578 = Bot(token, 578)
pbot579 = Bot(token, 579)
pbot580 = Bot(token, 580)
pbot581 = Bot(token, 581)
pbot582 = Bot(token, 582)
pbot583 = Bot(token, 583)
pbot584 = Bot(token, 584)
pbot585 = Bot(token, 585)
pbot586 = Bot(token, 586)
pbot587 = Bot(token, 587)
pbot588 = Bot(token, 588)
pbot589 = Bot(token, 589)
pbot590 = Bot(token, 590)
pbot591 = Bot(token, 591)
pbot592 = Bot(token, 592)
pbot593 = Bot(token, 593)
pbot594 = Bot(token, 594)
pbot595 = Bot(token, 595)
pbot596 = Bot(token, 596)
pbot597 = Bot(token, 597)
pbot598 = Bot(token, 598)
pbot599 = Bot(token, 599)
pbot600 = Bot(token, 600)
pbot601 = Bot(token, 601)
pbot602 = Bot(token, 602)
pbot603 = Bot(token, 603)
pbot604 = Bot(token, 604)
pbot605 = Bot(token, 605)
pbot606 = Bot(token, 606)
pbot607 = Bot(token, 607)
pbot608 = Bot(token, 608)
pbot609 = Bot(token, 609)
pbot610 = Bot(token, 610)
pbot611 = Bot(token, 611)
pbot612 = Bot(token, 612)
pbot613 = Bot(token, 613)
pbot614 = Bot(token, 614)
pbot615 = Bot(token, 615)
pbot616 = Bot(token, 616)
pbot617 = Bot(token, 617)
pbot618 = Bot(token, 618)
pbot619 = Bot(token, 619)
pbot620 = Bot(token, 620)
pbot621 = Bot(token, 621)
pbot622 = Bot(token, 622)
pbot623 = Bot(token, 623)
pbot624 = Bot(token, 624)
pbot625 = Bot(token, 625)
pbot626 = Bot(token, 626)
pbot627 = Bot(token, 627)
pbot628 = Bot(token, 628)
pbot629 = Bot(token, 629)
pbot630 = Bot(token, 630)
pbot631 = Bot(token, 631)
pbot632 = Bot(token, 632)
pbot633 = Bot(token, 633)
pbot634 = Bot(token, 634)
pbot635 = Bot(token, 635)
pbot636 = Bot(token, 636)
pbot637 = Bot(token, 637)
pbot638 = Bot(token, 638)
pbot639 = Bot(token, 639)
pbot640 = Bot(token, 640)
pbot641 = Bot(token, 641)
pbot642 = Bot(token, 642)
pbot643 = Bot(token, 643)
pbot644 = Bot(token, 644)
pbot645 = Bot(token, 645)
pbot646 = Bot(token, 646)
pbot647 = Bot(token, 647)
pbot648 = Bot(token, 648)
pbot649 = Bot(token, 649)
pbot650 = Bot(token, 650)
pbot651 = Bot(token, 651)
pbot652 = Bot(token, 652)
pbot653 = Bot(token, 653)
pbot654 = Bot(token, 654)
pbot655 = Bot(token, 655)
pbot656 = Bot(token, 656)
pbot657 = Bot(token, 657)
pbot658 = Bot(token, 658)
pbot659 = Bot(token, 659)
pbot660 = Bot(token, 660)
pbot661 = Bot(token, 661)
pbot662 = Bot(token, 662)
pbot663 = Bot(token, 663)
pbot664 = Bot(token, 664)
pbot665 = Bot(token, 665)
pbot666 = Bot(token, 666)
pbot667 = Bot(token, 667)
pbot668 = Bot(token, 668)
pbot669 = Bot(token, 669)
pbot670 = Bot(token, 670)
pbot671 = Bot(token, 671)
pbot672 = Bot(token, 672)
pbot673 = Bot(token, 673)
pbot674 = Bot(token, 674)
pbot675 = Bot(token, 675)
pbot676 = Bot(token, 676)
pbot677 = Bot(token, 677)
pbot678 = Bot(token, 678)
pbot679 = Bot(token, 679)
pbot680 = Bot(token, 680)
pbot681 = Bot(token, 681)
pbot682 = Bot(token, 682)
pbot683 = Bot(token, 683)
pbot684 = Bot(token, 684)
pbot685 = Bot(token, 685)
pbot686 = Bot(token, 686)
pbot687 = Bot(token, 687)
pbot688 = Bot(token, 688)
pbot689 = Bot(token, 689)
pbot690 = Bot(token, 690)
pbot691 = Bot(token, 691)
pbot692 = Bot(token, 692)
pbot693 = Bot(token, 693)
pbot694 = Bot(token, 694)
pbot695 = Bot(token, 695)
pbot696 = Bot(token, 696)
pbot697 = Bot(token, 697)
pbot698 = Bot(token, 698)
pbot699 = Bot(token, 699)
pbot700 = Bot(token, 700)
pbot701 = Bot(token, 701)
pbot702 = Bot(token, 702)
pbot703 = Bot(token, 703)
pbot704 = Bot(token, 704)
pbot705 = Bot(token, 705)
pbot706 = Bot(token, 706)
pbot707 = Bot(token, 707)
pbot708 = Bot(token, 708)
pbot709 = Bot(token, 709)
pbot710 = Bot(token, 710)
pbot711 = Bot(token, 711)
pbot712 = Bot(token, 712)
pbot713 = Bot(token, 713)
pbot714 = Bot(token, 714)
pbot715 = Bot(token, 715)
pbot716 = Bot(token, 716)
pbot717 = Bot(token, 717)
pbot718 = Bot(token, 718)
pbot719 = Bot(token, 719)
pbot720 = Bot(token, 720)
pbot721 = Bot(token, 721)
pbot722 = Bot(token, 722)
pbot723 = Bot(token, 723)
pbot724 = Bot(token, 724)
pbot725 = Bot(token, 795)
pbot726 = Bot(token, 726)
pbot727 = Bot(token, 727)
pbot728 = Bot(token, 728)
pbot729 = Bot(token, 729)
pbot730 = Bot(token, 730)
pbot731 = Bot(token, 731)
pbot732 = Bot(token, 732)
pbot733 = Bot(token, 733)
pbot734 = Bot(token, 734)
pbot735 = Bot(token, 735)
pbot736 = Bot(token, 736)
pbot737 = Bot(token, 737)
pbot738 = Bot(token, 738)
pbot739 = Bot(token, 739)
pbot740 = Bot(token, 740)
pbot741 = Bot(token, 741)
pbot742 = Bot(token, 742)
pbot743 = Bot(token, 743)
pbot744 = Bot(token, 744)
pbot745 = Bot(token, 745)
pbot746 = Bot(token, 746)
pbot747 = Bot(token, 747)
pbot748 = Bot(token, 748)
pbot749 = Bot(token, 749)
pbot750 = Bot(token, 750)
pbot751 = Bot(token, 751)
pbot752 = Bot(token, 752)
pbot753 = Bot(token, 753)
pbot754 = Bot(token, 754)
pbot755 = Bot(token, 755)
pbot756 = Bot(token, 756)
pbot757 = Bot(token, 757)
pbot758 = Bot(token, 758)
pbot759 = Bot(token, 759)
pbot760 = Bot(token, 760)
pbot761 = Bot(token, 761)
pbot762 = Bot(token, 762)
pbot763 = Bot(token, 763)
pbot764 = Bot(token, 764)
pbot765 = Bot(token, 765)
pbot766 = Bot(token, 766)
pbot767 = Bot(token, 767)
pbot768 = Bot(token, 768)
pbot769 = Bot(token, 769)
pbot770 = Bot(token, 770)
pbot771 = Bot(token, 771)
pbot772 = Bot(token, 772)
pbot773 = Bot(token, 773)
pbot774 = Bot(token, 774)
pbot775 = Bot(token, 775)
pbot776 = Bot(token, 776)
pbot777 = Bot(token, 777)
pbot778 = Bot(token, 778)
pbot779 = Bot(token, 779)
pbot780 = Bot(token, 780)
pbot781 = Bot(token, 781)
pbot782 = Bot(token, 782)
pbot783 = Bot(token, 783)
pbot784 = Bot(token, 784)
pbot785 = Bot(token, 785)
pbot786 = Bot(token, 786)
pbot787 = Bot(token, 787)
pbot788 = Bot(token, 788)
pbot789 = Bot(token, 789)
pbot790 = Bot(token, 790)
pbot791 = Bot(token, 791)
pbot792 = Bot(token, 792)
pbot793 = Bot(token, 793)
pbot794 = Bot(token, 794)
pbot795 = Bot(token, 795)
pbot796 = Bot(token, 796)
pbot797 = Bot(token, 797)
pbot798 = Bot(token, 798)
pbot799 = Bot(token, 799)
pbot800 = Bot(token, 800)
pbot801 = Bot(token, 801)
pbot802 = Bot(token, 802)
pbot803 = Bot(token, 803)
pbot804 = Bot(token, 804)
pbot805 = Bot(token, 805)
pbot806 = Bot(token, 806)
pbot807 = Bot(token, 807)
pbot808 = Bot(token, 808)
pbot809 = Bot(token, 809)
pbot810 = Bot(token, 810)
pbot811 = Bot(token, 811)
pbot812 = Bot(token, 812)
pbot813 = Bot(token, 813)
pbot814 = Bot(token, 814)
pbot815 = Bot(token, 815)
pbot816 = Bot(token, 816)
pbot817 = Bot(token, 817)
pbot818 = Bot(token, 818)
pbot819 = Bot(token, 819)
pbot820 = Bot(token, 820)
pbot821 = Bot(token, 821)
pbot822 = Bot(token, 822)
pbot823 = Bot(token, 823)
pbot824 = Bot(token, 824)
pbot825 = Bot(token, 825)
pbot826 = Bot(token, 826)
pbot827 = Bot(token, 827)
pbot828 = Bot(token, 828)
pbot829 = Bot(token, 829)
pbot830 = Bot(token, 830)
pbot831 = Bot(token, 831)
pbot832 = Bot(token, 832)
pbot833 = Bot(token, 833)
pbot834 = Bot(token, 834)
pbot835 = Bot(token, 835)
pbot836 = Bot(token, 836)
pbot837 = Bot(token, 837)
pbot838 = Bot(token, 838)
pbot839 = Bot(token, 839)
pbot840 = Bot(token, 840)
pbot841 = Bot(token, 841)
pbot842 = Bot(token, 842)
pbot843 = Bot(token, 843)
pbot844 = Bot(token, 844)
pbot845 = Bot(token, 845)
pbot846 = Bot(token, 846)
pbot847 = Bot(token, 847)
pbot848 = Bot(token, 848)
pbot849 = Bot(token, 849)
pbot850 = Bot(token, 850)
pbot851 = Bot(token, 851)
pbot852 = Bot(token, 852)
pbot853 = Bot(token, 853)
pbot854 = Bot(token, 854)
pbot855 = Bot(token, 855)
pbot856 = Bot(token, 856)
pbot857 = Bot(token, 857)
pbot858 = Bot(token, 858)
pbot859 = Bot(token, 859)
pbot860 = Bot(token, 860)
pbot861 = Bot(token, 861)
pbot862 = Bot(token, 862)
pbot863 = Bot(token, 863)
pbot864 = Bot(token, 864)
pbot865 = Bot(token, 865)
pbot866 = Bot(token, 866)
pbot867 = Bot(token, 867)
pbot868 = Bot(token, 868)
pbot869 = Bot(token, 869)
pbot870 = Bot(token, 870)
pbot871 = Bot(token, 871)
pbot872 = Bot(token, 872)
pbot873 = Bot(token, 873)
pbot874 = Bot(token, 874)
pbot875 = Bot(token, 875)
pbot876 = Bot(token, 876)
pbot877 = Bot(token, 877)
pbot878 = Bot(token, 878)
pbot879 = Bot(token, 879)
pbot880 = Bot(token, 880)
pbot881 = Bot(token, 881)
pbot882 = Bot(token, 882)
pbot883 = Bot(token, 883)
pbot884 = Bot(token, 884)
pbot885 = Bot(token, 885)
pbot886 = Bot(token, 886)
pbot887 = Bot(token, 887)
pbot888 = Bot(token, 888)
pbot889 = Bot(token, 889)
pbot890 = Bot(token, 890)
pbot891 = Bot(token, 891)
pbot892 = Bot(token, 892)
pbot893 = Bot(token, 893)
pbot894 = Bot(token, 894)
pbot895 = Bot(token, 895)
pbot896 = Bot(token, 896)
pbot897 = Bot(token, 897)
pbot898 = Bot(token, 898)
pbot899 = Bot(token, 899)
pbot900 = Bot(token, 900)
pbot901 = Bot(token, 901)
pbot902 = Bot(token, 902)
pbot903 = Bot(token, 903)
pbot904 = Bot(token, 904)
pbot905 = Bot(token, 905)
pbot906 = Bot(token, 906)
pbot907 = Bot(token, 907)
pbot908 = Bot(token, 908)
pbot909 = Bot(token, 909)
pbot910 = Bot(token, 910)
pbot911 = Bot(token, 911)
pbot912 = Bot(token, 912)
pbot913 = Bot(token, 913)
pbot914 = Bot(token, 914)
pbot915 = Bot(token, 915)
pbot916 = Bot(token, 916)
pbot917 = Bot(token, 917)
pbot918 = Bot(token, 918)
pbot919 = Bot(token, 919)
pbot920 = Bot(token, 920)
pbot921 = Bot(token, 921)
pbot922 = Bot(token, 922)
pbot923 = Bot(token, 923)
pbot924 = Bot(token, 924)
pbot925 = Bot(token, 925)
pbot926 = Bot(token, 926)
pbot927 = Bot(token, 927)
pbot928 = Bot(token, 928)
pbot929 = Bot(token, 929)
pbot930 = Bot(token, 930)
pbot931 = Bot(token, 931)
pbot932 = Bot(token, 932)
pbot933 = Bot(token, 933)
pbot934 = Bot(token, 934)
pbot935 = Bot(token, 935)
pbot936 = Bot(token, 936)
pbot937 = Bot(token, 937)
pbot938 = Bot(token, 938)
pbot939 = Bot(token, 939)
pbot940 = Bot(token, 940)
pbot941 = Bot(token, 941)
pbot942 = Bot(token, 942)
pbot943 = Bot(token, 943)
pbot944 = Bot(token, 944)
pbot945 = Bot(token, 945)
pbot946 = Bot(token, 946)
pbot947 = Bot(token, 947)
pbot948 = Bot(token, 948)
pbot949 = Bot(token, 949)
pbot950 = Bot(token, 950)
pbot951 = Bot(token, 951)
pbot952 = Bot(token, 952)
pbot953 = Bot(token, 953)
pbot954 = Bot(token, 954)
pbot955 = Bot(token, 955)
pbot956 = Bot(token, 956)
pbot957 = Bot(token, 957)
pbot958 = Bot(token, 958)
pbot959 = Bot(token, 959)
pbot960 = Bot(token, 960)
pbot961 = Bot(token, 961)
pbot962 = Bot(token, 962)
pbot963 = Bot(token, 963)
pbot964 = Bot(token, 964)
pbot965 = Bot(token, 965)
pbot966 = Bot(token, 966)
pbot967 = Bot(token, 967)
pbot968 = Bot(token, 968)
pbot969 = Bot(token, 969)
pbot970 = Bot(token, 970)
pbot971 = Bot(token, 971)
pbot972 = Bot(token, 972)
pbot973 = Bot(token, 973)
pbot974 = Bot(token, 974)
pbot975 = Bot(token, 975)
pbot976 = Bot(token, 976)
pbot977 = Bot(token, 977)
pbot978 = Bot(token, 978)
pbot979 = Bot(token, 979)
pbot980 = Bot(token, 980)
pbot981 = Bot(token, 981)
pbot982 = Bot(token, 982)
pbot983 = Bot(token, 983)
pbot984 = Bot(token, 984)
pbot985 = Bot(token, 985)
pbot986 = Bot(token, 986)
pbot987 = Bot(token, 987)
pbot988 = Bot(token, 988)
pbot989 = Bot(token, 989)
pbot990 = Bot(token, 990)
pbot991 = Bot(token, 991)
pbot992 = Bot(token, 992)
pbot993 = Bot(token, 993)
pbot994 = Bot(token, 994)
pbot995 = Bot(token, 995)
pbot996 = Bot(token, 996)
pbot997 = Bot(token, 997)
pbot998 = Bot(token, 998)
pbot999 = Bot(token, 999)


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
        pbot499.start(),
        pbot500.start(),
        pbot501.start(),
        pbot502.start(),
        pbot503.start(),
        pbot504.start(),
        pbot505.start(),
        pbot506.start(),
        pbot507.start(),
        pbot508.start(),
        pbot509.start(),
        pbot510.start(),
        pbot511.start(),
        pbot512.start(),
        pbot513.start(),
        pbot514.start(),
        pbot515.start(),
        pbot516.start(),
        pbot517.start(),
        pbot518.start(),
        pbot519.start(),
        pbot520.start(),
        pbot521.start(),
        pbot522.start(),
        pbot523.start(),
        pbot524.start(),
        pbot525.start(),
        pbot526.start(),
        pbot527.start(),
        pbot528.start(),
        pbot529.start(),
        pbot530.start(),
        pbot531.start(),
        pbot532.start(),
        pbot533.start(),
        pbot534.start(),
        pbot535.start(),
        pbot536.start(),
        pbot537.start(),
        pbot538.start(),
        pbot539.start(),
        pbot540.start(),
        pbot541.start(),
        pbot542.start(),
        pbot543.start(),
        pbot544.start(),
        pbot545.start(),
        pbot546.start(),
        pbot547.start(),
        pbot548.start(),
        pbot549.start(),
        pbot550.start(),
        pbot551.start(),
        pbot552.start(),
        pbot553.start(),
        pbot554.start(),
        pbot555.start(),
        pbot556.start(),
        pbot557.start(),
        pbot558.start(),
        pbot559.start(),
        pbot560.start(),
        pbot561.start(),
        pbot562.start(),
        pbot563.start(),
        pbot564.start(),
        pbot565.start(),
        pbot566.start(),
        pbot567.start(),
        pbot568.start(),
        pbot569.start(),
        pbot570.start(),
        pbot571.start(),
        pbot572.start(),
        pbot573.start(),
        pbot574.start(),
        pbot575.start(),
        pbot576.start(),
        pbot577.start(),
        pbot578.start(),
        pbot579.start(),
        pbot580.start(),
        pbot581.start(),
        pbot582.start(),
        pbot583.start(),
        pbot584.start(),
        pbot585.start(),
        pbot586.start(),
        pbot587.start(),
        pbot588.start(),
        pbot589.start(),
        pbot590.start(),
        pbot591.start(),
        pbot592.start(),
        pbot593.start(),
        pbot594.start(),
        pbot595.start(),
        pbot596.start(),
        pbot597.start(),
        pbot598.start(),
        pbot599.start(),
        pbot600.start(),
        pbot601.start(),
        pbot602.start(),
        pbot603.start(),
        pbot604.start(),
        pbot605.start(),
        pbot606.start(),
        pbot607.start(),
        pbot608.start(),
        pbot609.start(),
        pbot710.start(),
        pbot711.start(),
        pbot712.start(),
        pbot713.start(),
        pbot714.start(),
        pbot715.start(),
        pbot716.start(),
        pbot717.start(),
        pbot718.start(),
        pbot719.start(),
        pbot720.start(),
        pbot721.start(),
        pbot722.start(),
        pbot723.start(),
        pbot724.start(),
        pbot725.start(),
        pbot726.start(),
        pbot727.start(),
        pbot728.start(),
        pbot729.start(),
        pbot730.start(),
        pbot731.start(),
        pbot732.start(),
        pbot733.start(),
        pbot734.start(),
        pbot735.start(),
        pbot736.start(),
        pbot737.start(),
        pbot738.start(),
        pbot739.start(),
        pbot740.start(),
        pbot741.start(),
        pbot742.start(),
        pbot743.start(),
        pbot744.start(),
        pbot745.start(),
        pbot746.start(),
        pbot747.start(),
        pbot748.start(),
        pbot749.start(),
        pbot750.start(),
        pbot751.start(),
        pbot752.start(),
        pbot753.start(),
        pbot754.start(),
        pbot755.start(),
        pbot756.start(),
        pbot757.start(),
        pbot758.start(),
        pbot759.start(),
        pbot760.start(),
        pbot761.start(),
        pbot762.start(),
        pbot763.start(),
        pbot764.start(),
        pbot765.start(),
        pbot766.start(),
        pbot767.start(),
        pbot768.start(),
        pbot769.start(),
        pbot770.start(),
        pbot771.start(),
        pbot772.start(),
        pbot773.start(),
        pbot774.start(),
        pbot775.start(),
        pbot776.start(),
        pbot777.start(),
        pbot778.start(),
        pbot779.start(),
        pbot780.start(),
        pbot781.start(),
        pbot782.start(),
        pbot783.start(),
        pbot784.start(),
        pbot785.start(),
        pbot786.start(),
        pbot787.start(),
        pbot788.start(),
        pbot789.start(),
        pbot790.start(),
        pbot791.start(),
        pbot792.start(),
        pbot793.start(),
        pbot794.start(),
        pbot795.start(),
        pbot796.start(),
        pbot797.start(),
        pbot798.start(),
        pbot799.start(),
        pbot790.start(),
        pbot791.start(),
        pbot792.start(),
        pbot793.start(),
        pbot794.start(),
        pbot795.start(),
        pbot796.start(),
        pbot797.start(),
        pbot798.start(),
        pbot799.start(),
        pbot800.start(),
        pbot801.start(),
        pbot802.start(),
        pbot803.start(),
        pbot804.start(),
        pbot805.start(),
        pbot806.start(),
        pbot807.start(),
        pbot808.start(),
        pbot809.start(),
        pbot810.start(),
        pbot811.start(),
        pbot812.start(),
        pbot813.start(),
        pbot814.start(),
        pbot815.start(),
        pbot816.start(),
        pbot817.start(),
        pbot818.start(),
        pbot819.start(),
        pbot820.start(),
        pbot821.start(),
        pbot822.start(),
        pbot823.start(),
        pbot824.start(),
        pbot825.start(),
        pbot826.start(),
        pbot827.start(),
        pbot828.start(),
        pbot829.start(),
        pbot930.start(),
        pbot931.start(),
        pbot932.start(),
        pbot933.start(),
        pbot934.start(),
        pbot935.start(),
        pbot936.start(),
        pbot937.start(),
        pbot938.start(),
        pbot939.start(),
        pbot930.start(),
        pbot941.start(),
        pbot942.start(),
        pbot943.start(),
        pbot944.start(),
        pbot945.start(),
        pbot946.start(),
        pbot947.start(),
        pbot948.start(),
        pbot949.start(),
        pbot950.start(),
        pbot951.start(),
        pbot952.start(),
        pbot953.start(),
        pbot954.start(),
        pbot955.start(),
        pbot956.start(),
        pbot957.start(),
        pbot958.start(),
        pbot959.start(),
        pbot960.start(),
        pbot961.start(),
        pbot962.start(),
        pbot963.start(),
        pbot964.start(),
        pbot965.start(),
        pbot966.start(),
        pbot967.start(),
        pbot968.start(),
        pbot969.start(),
        pbot960.start(),
        pbot971.start(),
        pbot972.start(),
        pbot973.start(),
        pbot974.start(),
        pbot975.start(),
        pbot976.start(),
        pbot977.start(),
        pbot978.start(),
        pbot979.start(),
        pbot970.start(),
        pbot981.start(),
        pbot982.start(),
        pbot983.start(),
        pbot984.start(),
        pbot985.start(),
        pbot986.start(),
        pbot987.start(),
        pbot988.start(),
        pbot989.start(),
        pbot990.start(),
        pbot991.start(),
        pbot992.start(),
        pbot993.start(),
        pbot994.start(),
        pbot995.start(),
        pbot996.start(),
        pbot997.start(),
        pbot998.start(),
        pbot999.start()
        )


asyncio.run(main())
