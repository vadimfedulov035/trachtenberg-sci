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


cbot0 = Bot(token, 0)
cbot1 = Bot(token, 1)
cbot2 = Bot(token, 2)
cbot3 = Bot(token, 3)
cbot4 = Bot(token, 4)
cbot5 = Bot(token, 5)
cbot6 = Bot(token, 6)
cbot7 = Bot(token, 7)
cbot8 = Bot(token, 8)
cbot9 = Bot(token, 9)
cbot10 = Bot(token, 10)
cbot11 = Bot(token, 11)
cbot12 = Bot(token, 12)
cbot13 = Bot(token, 13)
cbot14 = Bot(token, 14)
cbot15 = Bot(token, 15)
cbot16 = Bot(token, 16)
cbot17 = Bot(token, 17)
cbot18 = Bot(token, 18)
cbot19 = Bot(token, 19)
cbot20 = Bot(token, 20)
cbot21 = Bot(token, 21)
cbot22 = Bot(token, 22)
cbot23 = Bot(token, 23)
cbot24 = Bot(token, 24)
cbot25 = Bot(token, 25)
cbot26 = Bot(token, 26)
cbot27 = Bot(token, 27)
cbot28 = Bot(token, 28)
cbot29 = Bot(token, 29)
cbot30 = Bot(token, 30)
cbot31 = Bot(token, 31)
cbot32 = Bot(token, 32)
cbot33 = Bot(token, 33)
cbot34 = Bot(token, 34)
cbot35 = Bot(token, 35)
cbot36 = Bot(token, 36)
cbot37 = Bot(token, 37)
cbot38 = Bot(token, 38)
cbot39 = Bot(token, 39)
cbot40 = Bot(token, 40)
cbot41 = Bot(token, 41)
cbot42 = Bot(token, 42)
cbot43 = Bot(token, 43)
cbot44 = Bot(token, 44)
cbot45 = Bot(token, 45)
cbot46 = Bot(token, 46)
cbot47 = Bot(token, 47)
cbot48 = Bot(token, 48)
cbot49 = Bot(token, 49)
cbot50 = Bot(token, 50)
cbot51 = Bot(token, 51)
cbot52 = Bot(token, 52)
cbot53 = Bot(token, 53)
cbot54 = Bot(token, 54)
cbot55 = Bot(token, 55)
cbot56 = Bot(token, 56)
cbot57 = Bot(token, 57)
cbot58 = Bot(token, 58)
cbot59 = Bot(token, 59)
cbot60 = Bot(token, 60)
cbot61 = Bot(token, 61)
cbot62 = Bot(token, 62)
cbot63 = Bot(token, 63)
cbot64 = Bot(token, 64)
cbot65 = Bot(token, 65)
cbot66 = Bot(token, 66)
cbot67 = Bot(token, 67)
cbot68 = Bot(token, 68)
cbot69 = Bot(token, 69)
cbot70 = Bot(token, 70)
cbot71 = Bot(token, 71)
cbot72 = Bot(token, 72)
cbot73 = Bot(token, 73)
cbot74 = Bot(token, 74)
cbot75 = Bot(token, 75)
cbot76 = Bot(token, 76)
cbot77 = Bot(token, 77)
cbot78 = Bot(token, 78)
cbot79 = Bot(token, 79)
cbot80 = Bot(token, 80)
cbot81 = Bot(token, 81)
cbot82 = Bot(token, 82)
cbot83 = Bot(token, 83)
cbot84 = Bot(token, 84)
cbot85 = Bot(token, 85)
cbot86 = Bot(token, 86)
cbot87 = Bot(token, 87)
cbot88 = Bot(token, 88)
cbot89 = Bot(token, 89)
cbot90 = Bot(token, 90)
cbot91 = Bot(token, 91)
cbot92 = Bot(token, 92)
cbot93 = Bot(token, 93)
cbot94 = Bot(token, 94)
cbot95 = Bot(token, 95)
cbot96 = Bot(token, 96)
cbot97 = Bot(token, 97)
cbot98 = Bot(token, 98)
cbot99 = Bot(token, 99)
cbot100 = Bot(token, 100)
cbot101 = Bot(token, 101)
cbot102 = Bot(token, 102)
cbot103 = Bot(token, 103)
cbot104 = Bot(token, 104)
cbot105 = Bot(token, 105)
cbot106 = Bot(token, 106)
cbot107 = Bot(token, 107)
cbot108 = Bot(token, 108)
cbot109 = Bot(token, 109)
cbot110 = Bot(token, 110)
cbot111 = Bot(token, 111)
cbot112 = Bot(token, 112)
cbot113 = Bot(token, 113)
cbot114 = Bot(token, 114)
cbot115 = Bot(token, 115)
cbot116 = Bot(token, 116)
cbot117 = Bot(token, 117)
cbot118 = Bot(token, 118)
cbot119 = Bot(token, 119)
cbot120 = Bot(token, 120)
cbot121 = Bot(token, 121)
cbot122 = Bot(token, 122)
cbot123 = Bot(token, 123)
cbot124 = Bot(token, 124)
cbot125 = Bot(token, 125)
cbot126 = Bot(token, 126)
cbot127 = Bot(token, 127)
cbot128 = Bot(token, 128)
cbot129 = Bot(token, 129)
cbot130 = Bot(token, 130)
cbot131 = Bot(token, 131)
cbot132 = Bot(token, 132)
cbot133 = Bot(token, 133)
cbot134 = Bot(token, 134)
cbot135 = Bot(token, 135)
cbot136 = Bot(token, 136)
cbot137 = Bot(token, 137)
cbot138 = Bot(token, 138)
cbot139 = Bot(token, 139)
cbot140 = Bot(token, 140)
cbot141 = Bot(token, 141)
cbot142 = Bot(token, 142)
cbot143 = Bot(token, 143)
cbot144 = Bot(token, 144)
cbot145 = Bot(token, 145)
cbot146 = Bot(token, 146)
cbot147 = Bot(token, 147)
cbot148 = Bot(token, 148)
cbot149 = Bot(token, 149)
cbot150 = Bot(token, 150)
cbot151 = Bot(token, 151)
cbot152 = Bot(token, 152)
cbot153 = Bot(token, 153)
cbot154 = Bot(token, 154)
cbot155 = Bot(token, 155)
cbot156 = Bot(token, 156)
cbot157 = Bot(token, 157)
cbot158 = Bot(token, 158)
cbot159 = Bot(token, 159)
cbot160 = Bot(token, 160)
cbot161 = Bot(token, 161)
cbot162 = Bot(token, 162)
cbot163 = Bot(token, 163)
cbot164 = Bot(token, 164)
cbot165 = Bot(token, 165)
cbot166 = Bot(token, 166)
cbot167 = Bot(token, 167)
cbot168 = Bot(token, 168)
cbot169 = Bot(token, 169)
cbot170 = Bot(token, 170)
cbot171 = Bot(token, 171)
cbot172 = Bot(token, 172)
cbot173 = Bot(token, 173)
cbot174 = Bot(token, 174)
cbot175 = Bot(token, 175)
cbot176 = Bot(token, 176)
cbot177 = Bot(token, 127)
cbot178 = Bot(token, 178)
cbot179 = Bot(token, 179)
cbot180 = Bot(token, 180)
cbot181 = Bot(token, 181)
cbot182 = Bot(token, 182)
cbot183 = Bot(token, 183)
cbot184 = Bot(token, 184)
cbot185 = Bot(token, 185)
cbot186 = Bot(token, 186)
cbot187 = Bot(token, 187)
cbot188 = Bot(token, 188)
cbot189 = Bot(token, 189)
cbot190 = Bot(token, 190)
cbot191 = Bot(token, 191)
cbot192 = Bot(token, 192)
cbot193 = Bot(token, 193)
cbot194 = Bot(token, 194)
cbot195 = Bot(token, 195)
cbot196 = Bot(token, 196)
cbot197 = Bot(token, 197)
cbot198 = Bot(token, 198)
cbot199 = Bot(token, 199)
cbot200 = Bot(token, 200)
cbot201 = Bot(token, 201)
cbot202 = Bot(token, 202)
cbot203 = Bot(token, 203)
cbot204 = Bot(token, 204)
cbot205 = Bot(token, 205)
cbot206 = Bot(token, 206)
cbot207 = Bot(token, 207)
cbot208 = Bot(token, 208)
cbot209 = Bot(token, 209)
cbot210 = Bot(token, 210)
cbot211 = Bot(token, 211)
cbot212 = Bot(token, 212)
cbot213 = Bot(token, 213)
cbot214 = Bot(token, 214)
cbot215 = Bot(token, 215)
cbot216 = Bot(token, 216)
cbot217 = Bot(token, 217)
cbot218 = Bot(token, 218)
cbot219 = Bot(token, 219)
cbot220 = Bot(token, 220)
cbot221 = Bot(token, 221)
cbot222 = Bot(token, 222)
cbot223 = Bot(token, 223)
cbot224 = Bot(token, 224)
cbot225 = Bot(token, 225)
cbot226 = Bot(token, 226)
cbot227 = Bot(token, 227)
cbot228 = Bot(token, 228)
cbot229 = Bot(token, 229)
cbot230 = Bot(token, 230)
cbot231 = Bot(token, 231)
cbot232 = Bot(token, 232)
cbot233 = Bot(token, 233)
cbot234 = Bot(token, 234)
cbot235 = Bot(token, 235)
cbot236 = Bot(token, 236)
cbot237 = Bot(token, 237)
cbot238 = Bot(token, 238)
cbot239 = Bot(token, 239)
cbot240 = Bot(token, 240)
cbot241 = Bot(token, 241)
cbot242 = Bot(token, 242)
cbot243 = Bot(token, 243)
cbot244 = Bot(token, 244)
cbot245 = Bot(token, 245)
cbot246 = Bot(token, 246)
cbot247 = Bot(token, 247)
cbot248 = Bot(token, 248)
cbot249 = Bot(token, 249)
cbot250 = Bot(token, 250)
cbot251 = Bot(token, 251)
cbot252 = Bot(token, 252)
cbot253 = Bot(token, 253)
cbot254 = Bot(token, 254)
cbot255 = Bot(token, 255)
cbot256 = Bot(token, 256)
cbot257 = Bot(token, 257)
cbot258 = Bot(token, 258)
cbot259 = Bot(token, 259)
cbot260 = Bot(token, 260)
cbot261 = Bot(token, 261)
cbot262 = Bot(token, 262)
cbot263 = Bot(token, 263)
cbot264 = Bot(token, 264)
cbot265 = Bot(token, 265)
cbot266 = Bot(token, 266)
cbot267 = Bot(token, 267)
cbot268 = Bot(token, 268)
cbot269 = Bot(token, 269)
cbot270 = Bot(token, 270)
cbot271 = Bot(token, 271)
cbot272 = Bot(token, 272)
cbot273 = Bot(token, 273)
cbot274 = Bot(token, 274)
cbot275 = Bot(token, 275)
cbot276 = Bot(token, 276)
cbot277 = Bot(token, 277)
cbot278 = Bot(token, 278)
cbot279 = Bot(token, 279)
cbot280 = Bot(token, 280)
cbot281 = Bot(token, 281)
cbot282 = Bot(token, 282)
cbot283 = Bot(token, 283)
cbot284 = Bot(token, 284)
cbot285 = Bot(token, 285)
cbot286 = Bot(token, 286)
cbot287 = Bot(token, 287)
cbot288 = Bot(token, 288)
cbot289 = Bot(token, 289)
cbot290 = Bot(token, 280)
cbot291 = Bot(token, 291)
cbot292 = Bot(token, 292)
cbot293 = Bot(token, 293)
cbot294 = Bot(token, 294)
cbot295 = Bot(token, 295)
cbot296 = Bot(token, 296)
cbot297 = Bot(token, 297)
cbot298 = Bot(token, 298)
cbot299 = Bot(token, 299)
cbot300 = Bot(token, 300)
cbot301 = Bot(token, 301)
cbot302 = Bot(token, 302)
cbot303 = Bot(token, 303)
cbot304 = Bot(token, 304)
cbot305 = Bot(token, 305)
cbot306 = Bot(token, 306)
cbot307 = Bot(token, 307)
cbot308 = Bot(token, 308)
cbot309 = Bot(token, 309)
cbot310 = Bot(token, 310)
cbot311 = Bot(token, 311)
cbot312 = Bot(token, 312)
cbot313 = Bot(token, 313)
cbot314 = Bot(token, 314)
cbot315 = Bot(token, 315)
cbot316 = Bot(token, 316)
cbot317 = Bot(token, 317)
cbot318 = Bot(token, 318)
cbot319 = Bot(token, 319)
cbot320 = Bot(token, 320)
cbot321 = Bot(token, 321)
cbot322 = Bot(token, 322)
cbot323 = Bot(token, 223)
cbot324 = Bot(token, 324)
cbot325 = Bot(token, 325)
cbot326 = Bot(token, 326)
cbot327 = Bot(token, 327)
cbot328 = Bot(token, 328)
cbot329 = Bot(token, 329)
cbot330 = Bot(token, 330)
cbot331 = Bot(token, 331)
cbot332 = Bot(token, 332)
cbot333 = Bot(token, 333)
cbot334 = Bot(token, 334)
cbot335 = Bot(token, 335)
cbot336 = Bot(token, 336)
cbot337 = Bot(token, 337)
cbot338 = Bot(token, 338)
cbot339 = Bot(token, 339)
cbot340 = Bot(token, 330)
cbot341 = Bot(token, 341)
cbot342 = Bot(token, 342)
cbot343 = Bot(token, 343)
cbot344 = Bot(token, 344)
cbot345 = Bot(token, 345)
cbot346 = Bot(token, 346)
cbot347 = Bot(token, 347)
cbot348 = Bot(token, 348)
cbot349 = Bot(token, 349)
cbot350 = Bot(token, 350)
cbot351 = Bot(token, 351)
cbot352 = Bot(token, 352)
cbot353 = Bot(token, 353)
cbot354 = Bot(token, 354)
cbot355 = Bot(token, 355)
cbot356 = Bot(token, 356)
cbot357 = Bot(token, 357)
cbot358 = Bot(token, 358)
cbot359 = Bot(token, 359)
cbot360 = Bot(token, 360)
cbot361 = Bot(token, 361)
cbot362 = Bot(token, 362)
cbot363 = Bot(token, 363)
cbot364 = Bot(token, 364)
cbot365 = Bot(token, 365)
cbot366 = Bot(token, 366)
cbot367 = Bot(token, 367)
cbot368 = Bot(token, 368)
cbot369 = Bot(token, 369)
cbot370 = Bot(token, 370)
cbot371 = Bot(token, 371)
cbot372 = Bot(token, 372)
cbot373 = Bot(token, 273)
cbot374 = Bot(token, 374)
cbot375 = Bot(token, 375)
cbot376 = Bot(token, 376)
cbot377 = Bot(token, 377)
cbot378 = Bot(token, 378)
cbot379 = Bot(token, 379)
cbot380 = Bot(token, 380)
cbot381 = Bot(token, 381)
cbot382 = Bot(token, 382)
cbot383 = Bot(token, 383)
cbot384 = Bot(token, 384)
cbot385 = Bot(token, 385)
cbot386 = Bot(token, 386)
cbot387 = Bot(token, 387)
cbot388 = Bot(token, 388)
cbot389 = Bot(token, 389)
cbot390 = Bot(token, 380)
cbot391 = Bot(token, 391)
cbot392 = Bot(token, 392)
cbot393 = Bot(token, 393)
cbot394 = Bot(token, 394)
cbot395 = Bot(token, 395)
cbot396 = Bot(token, 396)
cbot397 = Bot(token, 397)
cbot398 = Bot(token, 398)
cbot399 = Bot(token, 399)
cbot400 = Bot(token, 400)
cbot401 = Bot(token, 401)
cbot402 = Bot(token, 402)
cbot403 = Bot(token, 403)
cbot404 = Bot(token, 404)
cbot405 = Bot(token, 405)
cbot406 = Bot(token, 406)
cbot407 = Bot(token, 407)
cbot408 = Bot(token, 408)
cbot409 = Bot(token, 409)
cbot410 = Bot(token, 410)
cbot411 = Bot(token, 411)
cbot412 = Bot(token, 412)
cbot413 = Bot(token, 413)
cbot414 = Bot(token, 414)
cbot415 = Bot(token, 415)
cbot416 = Bot(token, 416)
cbot417 = Bot(token, 417)
cbot418 = Bot(token, 418)
cbot419 = Bot(token, 419)
cbot420 = Bot(token, 420)
cbot421 = Bot(token, 421)
cbot422 = Bot(token, 422)
cbot423 = Bot(token, 423)
cbot424 = Bot(token, 424)
cbot425 = Bot(token, 425)
cbot426 = Bot(token, 426)
cbot427 = Bot(token, 427)
cbot428 = Bot(token, 428)
cbot429 = Bot(token, 429)
cbot430 = Bot(token, 430)
cbot431 = Bot(token, 431)
cbot432 = Bot(token, 432)
cbot433 = Bot(token, 433)
cbot434 = Bot(token, 434)
cbot435 = Bot(token, 435)
cbot436 = Bot(token, 436)
cbot437 = Bot(token, 437)
cbot438 = Bot(token, 438)
cbot439 = Bot(token, 439)
cbot440 = Bot(token, 430)
cbot441 = Bot(token, 441)
cbot442 = Bot(token, 442)
cbot443 = Bot(token, 443)
cbot444 = Bot(token, 444)
cbot445 = Bot(token, 445)
cbot446 = Bot(token, 446)
cbot447 = Bot(token, 447)
cbot448 = Bot(token, 448)
cbot449 = Bot(token, 449)
cbot450 = Bot(token, 450)
cbot451 = Bot(token, 451)
cbot452 = Bot(token, 452)
cbot453 = Bot(token, 453)
cbot454 = Bot(token, 454)
cbot455 = Bot(token, 455)
cbot456 = Bot(token, 456)
cbot457 = Bot(token, 457)
cbot458 = Bot(token, 458)
cbot459 = Bot(token, 459)
cbot460 = Bot(token, 460)
cbot461 = Bot(token, 461)
cbot462 = Bot(token, 462)
cbot463 = Bot(token, 463)
cbot464 = Bot(token, 464)
cbot465 = Bot(token, 465)
cbot466 = Bot(token, 466)
cbot467 = Bot(token, 467)
cbot468 = Bot(token, 468)
cbot469 = Bot(token, 469)
cbot470 = Bot(token, 470)
cbot471 = Bot(token, 471)
cbot472 = Bot(token, 472)
cbot473 = Bot(token, 473)
cbot474 = Bot(token, 474)
cbot475 = Bot(token, 475)
cbot476 = Bot(token, 476)
cbot477 = Bot(token, 477)
cbot478 = Bot(token, 478)
cbot479 = Bot(token, 479)
cbot480 = Bot(token, 480)
cbot481 = Bot(token, 481)
cbot482 = Bot(token, 482)
cbot483 = Bot(token, 483)
cbot484 = Bot(token, 484)
cbot485 = Bot(token, 485)
cbot486 = Bot(token, 486)
cbot487 = Bot(token, 487)
cbot488 = Bot(token, 488)
cbot489 = Bot(token, 489)
cbot490 = Bot(token, 490)
cbot491 = Bot(token, 491)
cbot492 = Bot(token, 492)
cbot493 = Bot(token, 493)
cbot494 = Bot(token, 494)
cbot495 = Bot(token, 495)
cbot496 = Bot(token, 496)
cbot497 = Bot(token, 497)
cbot498 = Bot(token, 498)
cbot499 = Bot(token, 499)
cbot500 = Bot(token, 500)
cbot501 = Bot(token, 501)
cbot502 = Bot(token, 502)
cbot503 = Bot(token, 503)
cbot504 = Bot(token, 504)
cbot505 = Bot(token, 505)
cbot506 = Bot(token, 506)
cbot507 = Bot(token, 507)
cbot508 = Bot(token, 508)
cbot509 = Bot(token, 509)
cbot510 = Bot(token, 510)
cbot511 = Bot(token, 511)
cbot512 = Bot(token, 512)
cbot513 = Bot(token, 513)
cbot514 = Bot(token, 514)
cbot515 = Bot(token, 515)
cbot516 = Bot(token, 516)
cbot517 = Bot(token, 517)
cbot518 = Bot(token, 518)
cbot519 = Bot(token, 519)
cbot520 = Bot(token, 520)
cbot521 = Bot(token, 521)
cbot522 = Bot(token, 522)
cbot523 = Bot(token, 523)
cbot524 = Bot(token, 524)
cbot525 = Bot(token, 525)
cbot526 = Bot(token, 526)
cbot527 = Bot(token, 527)
cbot528 = Bot(token, 528)
cbot529 = Bot(token, 529)
cbot530 = Bot(token, 530)
cbot531 = Bot(token, 531)
cbot532 = Bot(token, 532)
cbot533 = Bot(token, 533)
cbot534 = Bot(token, 534)
cbot535 = Bot(token, 535)
cbot536 = Bot(token, 536)
cbot537 = Bot(token, 537)
cbot538 = Bot(token, 538)
cbot539 = Bot(token, 539)
cbot540 = Bot(token, 540)
cbot541 = Bot(token, 541)
cbot542 = Bot(token, 542)
cbot543 = Bot(token, 543)
cbot544 = Bot(token, 544)
cbot545 = Bot(token, 545)
cbot546 = Bot(token, 546)
cbot547 = Bot(token, 547)
cbot548 = Bot(token, 548)
cbot549 = Bot(token, 549)
cbot550 = Bot(token, 550)
cbot551 = Bot(token, 551)
cbot552 = Bot(token, 552)
cbot553 = Bot(token, 553)
cbot554 = Bot(token, 554)
cbot555 = Bot(token, 555)
cbot556 = Bot(token, 556)
cbot557 = Bot(token, 557)
cbot558 = Bot(token, 558)
cbot559 = Bot(token, 559)
cbot560 = Bot(token, 560)
cbot561 = Bot(token, 561)
cbot562 = Bot(token, 562)
cbot563 = Bot(token, 563)
cbot564 = Bot(token, 564)
cbot565 = Bot(token, 565)
cbot566 = Bot(token, 566)
cbot567 = Bot(token, 567)
cbot568 = Bot(token, 568)
cbot569 = Bot(token, 569)
cbot570 = Bot(token, 570)
cbot571 = Bot(token, 571)
cbot572 = Bot(token, 572)
cbot573 = Bot(token, 573)
cbot574 = Bot(token, 574)
cbot575 = Bot(token, 575)
cbot576 = Bot(token, 576)
cbot577 = Bot(token, 577)
cbot578 = Bot(token, 578)
cbot579 = Bot(token, 579)
cbot580 = Bot(token, 580)
cbot581 = Bot(token, 581)
cbot582 = Bot(token, 582)
cbot583 = Bot(token, 583)
cbot584 = Bot(token, 584)
cbot585 = Bot(token, 585)
cbot586 = Bot(token, 586)
cbot587 = Bot(token, 587)
cbot588 = Bot(token, 588)
cbot589 = Bot(token, 589)
cbot590 = Bot(token, 590)
cbot591 = Bot(token, 591)
cbot592 = Bot(token, 592)
cbot593 = Bot(token, 593)
cbot594 = Bot(token, 594)
cbot595 = Bot(token, 595)
cbot596 = Bot(token, 596)
cbot597 = Bot(token, 597)
cbot598 = Bot(token, 598)
cbot599 = Bot(token, 599)
cbot600 = Bot(token, 600)
cbot601 = Bot(token, 601)
cbot602 = Bot(token, 602)
cbot603 = Bot(token, 603)
cbot604 = Bot(token, 604)
cbot605 = Bot(token, 605)
cbot606 = Bot(token, 606)
cbot607 = Bot(token, 607)
cbot608 = Bot(token, 608)
cbot609 = Bot(token, 609)
cbot610 = Bot(token, 610)
cbot611 = Bot(token, 611)
cbot612 = Bot(token, 612)
cbot613 = Bot(token, 613)
cbot614 = Bot(token, 614)
cbot615 = Bot(token, 615)
cbot616 = Bot(token, 616)
cbot617 = Bot(token, 617)
cbot618 = Bot(token, 618)
cbot619 = Bot(token, 619)
cbot620 = Bot(token, 620)
cbot621 = Bot(token, 621)
cbot622 = Bot(token, 622)
cbot623 = Bot(token, 623)
cbot624 = Bot(token, 624)
cbot625 = Bot(token, 625)
cbot626 = Bot(token, 626)
cbot627 = Bot(token, 627)
cbot628 = Bot(token, 628)
cbot629 = Bot(token, 629)
cbot630 = Bot(token, 630)
cbot631 = Bot(token, 631)
cbot632 = Bot(token, 632)
cbot633 = Bot(token, 633)
cbot634 = Bot(token, 634)
cbot635 = Bot(token, 635)
cbot636 = Bot(token, 636)
cbot637 = Bot(token, 637)
cbot638 = Bot(token, 638)
cbot639 = Bot(token, 639)
cbot640 = Bot(token, 640)
cbot641 = Bot(token, 641)
cbot642 = Bot(token, 642)
cbot643 = Bot(token, 643)
cbot644 = Bot(token, 644)
cbot645 = Bot(token, 645)
cbot646 = Bot(token, 646)
cbot647 = Bot(token, 647)
cbot648 = Bot(token, 648)
cbot649 = Bot(token, 649)
cbot650 = Bot(token, 650)
cbot651 = Bot(token, 651)
cbot652 = Bot(token, 652)
cbot653 = Bot(token, 653)
cbot654 = Bot(token, 654)
cbot655 = Bot(token, 655)
cbot656 = Bot(token, 656)
cbot657 = Bot(token, 657)
cbot658 = Bot(token, 658)
cbot659 = Bot(token, 659)
cbot660 = Bot(token, 660)
cbot661 = Bot(token, 661)
cbot662 = Bot(token, 662)
cbot663 = Bot(token, 663)
cbot664 = Bot(token, 664)
cbot665 = Bot(token, 665)
cbot666 = Bot(token, 666)
cbot667 = Bot(token, 667)
cbot668 = Bot(token, 668)
cbot669 = Bot(token, 669)
cbot670 = Bot(token, 670)
cbot671 = Bot(token, 671)
cbot672 = Bot(token, 672)
cbot673 = Bot(token, 673)
cbot674 = Bot(token, 674)
cbot675 = Bot(token, 675)
cbot676 = Bot(token, 676)
cbot677 = Bot(token, 677)
cbot678 = Bot(token, 678)
cbot679 = Bot(token, 679)
cbot680 = Bot(token, 680)
cbot681 = Bot(token, 681)
cbot682 = Bot(token, 682)
cbot683 = Bot(token, 683)
cbot684 = Bot(token, 684)
cbot685 = Bot(token, 685)
cbot686 = Bot(token, 686)
cbot687 = Bot(token, 687)
cbot688 = Bot(token, 688)
cbot689 = Bot(token, 689)
cbot690 = Bot(token, 690)
cbot691 = Bot(token, 691)
cbot692 = Bot(token, 692)
cbot693 = Bot(token, 693)
cbot694 = Bot(token, 694)
cbot695 = Bot(token, 695)
cbot696 = Bot(token, 696)
cbot697 = Bot(token, 697)
cbot698 = Bot(token, 698)
cbot699 = Bot(token, 699)
cbot700 = Bot(token, 700)
cbot701 = Bot(token, 701)
cbot702 = Bot(token, 702)
cbot703 = Bot(token, 703)
cbot704 = Bot(token, 704)
cbot705 = Bot(token, 705)
cbot706 = Bot(token, 706)
cbot707 = Bot(token, 707)
cbot708 = Bot(token, 708)
cbot709 = Bot(token, 709)
cbot710 = Bot(token, 710)
cbot711 = Bot(token, 711)
cbot712 = Bot(token, 712)
cbot713 = Bot(token, 713)
cbot714 = Bot(token, 714)
cbot715 = Bot(token, 715)
cbot716 = Bot(token, 716)
cbot717 = Bot(token, 717)
cbot718 = Bot(token, 718)
cbot719 = Bot(token, 719)
cbot720 = Bot(token, 720)
cbot721 = Bot(token, 721)
cbot722 = Bot(token, 722)
cbot723 = Bot(token, 723)
cbot724 = Bot(token, 724)
cbot725 = Bot(token, 795)
cbot726 = Bot(token, 726)
cbot727 = Bot(token, 727)
cbot728 = Bot(token, 728)
cbot729 = Bot(token, 729)
cbot730 = Bot(token, 730)
cbot731 = Bot(token, 731)
cbot732 = Bot(token, 732)
cbot733 = Bot(token, 733)
cbot734 = Bot(token, 734)
cbot735 = Bot(token, 735)
cbot736 = Bot(token, 736)
cbot737 = Bot(token, 737)
cbot738 = Bot(token, 738)
cbot739 = Bot(token, 739)
cbot740 = Bot(token, 740)
cbot741 = Bot(token, 741)
cbot742 = Bot(token, 742)
cbot743 = Bot(token, 743)
cbot744 = Bot(token, 744)
cbot745 = Bot(token, 745)
cbot746 = Bot(token, 746)
cbot747 = Bot(token, 747)
cbot748 = Bot(token, 748)
cbot749 = Bot(token, 749)
cbot750 = Bot(token, 750)
cbot751 = Bot(token, 751)
cbot752 = Bot(token, 752)
cbot753 = Bot(token, 753)
cbot754 = Bot(token, 754)
cbot755 = Bot(token, 755)
cbot756 = Bot(token, 756)
cbot757 = Bot(token, 757)
cbot758 = Bot(token, 758)
cbot759 = Bot(token, 759)
cbot760 = Bot(token, 760)
cbot761 = Bot(token, 761)
cbot762 = Bot(token, 762)
cbot763 = Bot(token, 763)
cbot764 = Bot(token, 764)
cbot765 = Bot(token, 765)
cbot766 = Bot(token, 766)
cbot767 = Bot(token, 767)
cbot768 = Bot(token, 768)
cbot769 = Bot(token, 769)
cbot770 = Bot(token, 770)
cbot771 = Bot(token, 771)
cbot772 = Bot(token, 772)
cbot773 = Bot(token, 773)
cbot774 = Bot(token, 774)
cbot775 = Bot(token, 775)
cbot776 = Bot(token, 776)
cbot777 = Bot(token, 777)
cbot778 = Bot(token, 778)
cbot779 = Bot(token, 779)
cbot780 = Bot(token, 780)
cbot781 = Bot(token, 781)
cbot782 = Bot(token, 782)
cbot783 = Bot(token, 783)
cbot784 = Bot(token, 784)
cbot785 = Bot(token, 785)
cbot786 = Bot(token, 786)
cbot787 = Bot(token, 787)
cbot788 = Bot(token, 788)
cbot789 = Bot(token, 789)
cbot790 = Bot(token, 790)
cbot791 = Bot(token, 791)
cbot792 = Bot(token, 792)
cbot793 = Bot(token, 793)
cbot794 = Bot(token, 794)
cbot795 = Bot(token, 795)
cbot796 = Bot(token, 796)
cbot797 = Bot(token, 797)
cbot798 = Bot(token, 798)
cbot799 = Bot(token, 799)
cbot800 = Bot(token, 800)
cbot801 = Bot(token, 801)
cbot802 = Bot(token, 802)
cbot803 = Bot(token, 803)
cbot804 = Bot(token, 804)
cbot805 = Bot(token, 805)
cbot806 = Bot(token, 806)
cbot807 = Bot(token, 807)
cbot808 = Bot(token, 808)
cbot809 = Bot(token, 809)
cbot810 = Bot(token, 810)
cbot811 = Bot(token, 811)
cbot812 = Bot(token, 812)
cbot813 = Bot(token, 813)
cbot814 = Bot(token, 814)
cbot815 = Bot(token, 815)
cbot816 = Bot(token, 816)
cbot817 = Bot(token, 817)
cbot818 = Bot(token, 818)
cbot819 = Bot(token, 819)
cbot820 = Bot(token, 820)
cbot821 = Bot(token, 821)
cbot822 = Bot(token, 822)
cbot823 = Bot(token, 823)
cbot824 = Bot(token, 824)
cbot825 = Bot(token, 825)
cbot826 = Bot(token, 826)
cbot827 = Bot(token, 827)
cbot828 = Bot(token, 828)
cbot829 = Bot(token, 829)
cbot830 = Bot(token, 830)
cbot831 = Bot(token, 831)
cbot832 = Bot(token, 832)
cbot833 = Bot(token, 833)
cbot834 = Bot(token, 834)
cbot835 = Bot(token, 835)
cbot836 = Bot(token, 836)
cbot837 = Bot(token, 837)
cbot838 = Bot(token, 838)
cbot839 = Bot(token, 839)
cbot840 = Bot(token, 840)
cbot841 = Bot(token, 841)
cbot842 = Bot(token, 842)
cbot843 = Bot(token, 843)
cbot844 = Bot(token, 844)
cbot845 = Bot(token, 845)
cbot846 = Bot(token, 846)
cbot847 = Bot(token, 847)
cbot848 = Bot(token, 848)
cbot849 = Bot(token, 849)
cbot850 = Bot(token, 850)
cbot851 = Bot(token, 851)
cbot852 = Bot(token, 852)
cbot853 = Bot(token, 853)
cbot854 = Bot(token, 854)
cbot855 = Bot(token, 855)
cbot856 = Bot(token, 856)
cbot857 = Bot(token, 857)
cbot858 = Bot(token, 858)
cbot859 = Bot(token, 859)
cbot860 = Bot(token, 860)
cbot861 = Bot(token, 861)
cbot862 = Bot(token, 862)
cbot863 = Bot(token, 863)
cbot864 = Bot(token, 864)
cbot865 = Bot(token, 865)
cbot866 = Bot(token, 866)
cbot867 = Bot(token, 867)
cbot868 = Bot(token, 868)
cbot869 = Bot(token, 869)
cbot870 = Bot(token, 870)
cbot871 = Bot(token, 871)
cbot872 = Bot(token, 872)
cbot873 = Bot(token, 873)
cbot874 = Bot(token, 874)
cbot875 = Bot(token, 875)
cbot876 = Bot(token, 876)
cbot877 = Bot(token, 877)
cbot878 = Bot(token, 878)
cbot879 = Bot(token, 879)
cbot880 = Bot(token, 880)
cbot881 = Bot(token, 881)
cbot882 = Bot(token, 882)
cbot883 = Bot(token, 883)
cbot884 = Bot(token, 884)
cbot885 = Bot(token, 885)
cbot886 = Bot(token, 886)
cbot887 = Bot(token, 887)
cbot888 = Bot(token, 888)
cbot889 = Bot(token, 889)
cbot890 = Bot(token, 890)
cbot891 = Bot(token, 891)
cbot892 = Bot(token, 892)
cbot893 = Bot(token, 893)
cbot894 = Bot(token, 894)
cbot895 = Bot(token, 895)
cbot896 = Bot(token, 896)
cbot897 = Bot(token, 897)
cbot898 = Bot(token, 898)
cbot899 = Bot(token, 899)
cbot900 = Bot(token, 900)
cbot901 = Bot(token, 901)
cbot902 = Bot(token, 902)
cbot903 = Bot(token, 903)
cbot904 = Bot(token, 904)
cbot905 = Bot(token, 905)
cbot906 = Bot(token, 906)
cbot907 = Bot(token, 907)
cbot908 = Bot(token, 908)
cbot909 = Bot(token, 909)
cbot910 = Bot(token, 910)
cbot911 = Bot(token, 911)
cbot912 = Bot(token, 912)
cbot913 = Bot(token, 913)
cbot914 = Bot(token, 914)
cbot915 = Bot(token, 915)
cbot916 = Bot(token, 916)
cbot917 = Bot(token, 917)
cbot918 = Bot(token, 918)
cbot919 = Bot(token, 919)
cbot920 = Bot(token, 920)
cbot921 = Bot(token, 921)
cbot922 = Bot(token, 922)
cbot923 = Bot(token, 923)
cbot924 = Bot(token, 924)
cbot925 = Bot(token, 925)
cbot926 = Bot(token, 926)
cbot927 = Bot(token, 927)
cbot928 = Bot(token, 928)
cbot929 = Bot(token, 929)
cbot930 = Bot(token, 930)
cbot931 = Bot(token, 931)
cbot932 = Bot(token, 932)
cbot933 = Bot(token, 933)
cbot934 = Bot(token, 934)
cbot935 = Bot(token, 935)
cbot936 = Bot(token, 936)
cbot937 = Bot(token, 937)
cbot938 = Bot(token, 938)
cbot939 = Bot(token, 939)
cbot940 = Bot(token, 940)
cbot941 = Bot(token, 941)
cbot942 = Bot(token, 942)
cbot943 = Bot(token, 943)
cbot944 = Bot(token, 944)
cbot945 = Bot(token, 945)
cbot946 = Bot(token, 946)
cbot947 = Bot(token, 947)
cbot948 = Bot(token, 948)
cbot949 = Bot(token, 949)
cbot950 = Bot(token, 950)
cbot951 = Bot(token, 951)
cbot952 = Bot(token, 952)
cbot953 = Bot(token, 953)
cbot954 = Bot(token, 954)
cbot955 = Bot(token, 955)
cbot956 = Bot(token, 956)
cbot957 = Bot(token, 957)
cbot958 = Bot(token, 958)
cbot959 = Bot(token, 959)
cbot960 = Bot(token, 960)
cbot961 = Bot(token, 961)
cbot962 = Bot(token, 962)
cbot963 = Bot(token, 963)
cbot964 = Bot(token, 964)
cbot965 = Bot(token, 965)
cbot966 = Bot(token, 966)
cbot967 = Bot(token, 967)
cbot968 = Bot(token, 968)
cbot969 = Bot(token, 969)
cbot970 = Bot(token, 970)
cbot971 = Bot(token, 971)
cbot972 = Bot(token, 972)
cbot973 = Bot(token, 973)
cbot974 = Bot(token, 974)
cbot975 = Bot(token, 975)
cbot976 = Bot(token, 976)
cbot977 = Bot(token, 977)
cbot978 = Bot(token, 978)
cbot979 = Bot(token, 979)
cbot980 = Bot(token, 980)
cbot981 = Bot(token, 981)
cbot982 = Bot(token, 982)
cbot983 = Bot(token, 983)
cbot984 = Bot(token, 984)
cbot985 = Bot(token, 985)
cbot986 = Bot(token, 986)
cbot987 = Bot(token, 987)
cbot988 = Bot(token, 988)
cbot989 = Bot(token, 989)
cbot990 = Bot(token, 990)
cbot991 = Bot(token, 991)
cbot992 = Bot(token, 992)
cbot993 = Bot(token, 993)
cbot994 = Bot(token, 994)
cbot995 = Bot(token, 995)
cbot996 = Bot(token, 996)
cbot997 = Bot(token, 997)
cbot998 = Bot(token, 998)
cbot999 = Bot(token, 999)


async def main():
    await asyncio.gather(
        cbot0.start(),
        cbot1.start(),
        cbot2.start(),
        cbot3.start(),
        cbot4.start(),
        cbot5.start(),
        cbot6.start(),
        cbot7.start(),
        cbot8.start(),
        cbot9.start(),
        cbot10.start(),
        cbot11.start(),
        cbot12.start(),
        cbot13.start(),
        cbot14.start(),
        cbot15.start(),
        cbot16.start(),
        cbot17.start(),
        cbot18.start(),
        cbot19.start(),
        cbot20.start(),
        cbot21.start(),
        cbot22.start(),
        cbot23.start(),
        cbot24.start(),
        cbot25.start(),
        cbot26.start(),
        cbot27.start(),
        cbot28.start(),
        cbot29.start(),
        cbot30.start(),
        cbot31.start(),
        cbot32.start(),
        cbot33.start(),
        cbot34.start(),
        cbot35.start(),
        cbot36.start(),
        cbot37.start(),
        cbot38.start(),
        cbot39.start(),
        cbot40.start(),
        cbot41.start(),
        cbot42.start(),
        cbot43.start(),
        cbot44.start(),
        cbot45.start(),
        cbot46.start(),
        cbot47.start(),
        cbot48.start(),
        cbot49.start(),
        cbot50.start(),
        cbot51.start(),
        cbot52.start(),
        cbot53.start(),
        cbot54.start(),
        cbot55.start(),
        cbot56.start(),
        cbot57.start(),
        cbot58.start(),
        cbot59.start(),
        cbot60.start(),
        cbot61.start(),
        cbot62.start(),
        cbot63.start(),
        cbot64.start(),
        cbot65.start(),
        cbot66.start(),
        cbot67.start(),
        cbot68.start(),
        cbot69.start(),
        cbot70.start(),
        cbot71.start(),
        cbot72.start(),
        cbot73.start(),
        cbot74.start(),
        cbot75.start(),
        cbot76.start(),
        cbot77.start(),
        cbot78.start(),
        cbot79.start(),
        cbot80.start(),
        cbot81.start(),
        cbot82.start(),
        cbot83.start(),
        cbot84.start(),
        cbot85.start(),
        cbot86.start(),
        cbot87.start(),
        cbot88.start(),
        cbot89.start(),
        cbot90.start(),
        cbot91.start(),
        cbot92.start(),
        cbot93.start(),
        cbot94.start(),
        cbot95.start(),
        cbot96.start(),
        cbot97.start(),
        cbot98.start(),
        cbot99.start(),
        cbot100.start(),
        cbot101.start(),
        cbot102.start(),
        cbot103.start(),
        cbot104.start(),
        cbot105.start(),
        cbot106.start(),
        cbot107.start(),
        cbot108.start(),
        cbot109.start(),
        cbot110.start(),
        cbot111.start(),
        cbot112.start(),
        cbot113.start(),
        cbot114.start(),
        cbot115.start(),
        cbot116.start(),
        cbot117.start(),
        cbot118.start(),
        cbot119.start(),
        cbot120.start(),
        cbot121.start(),
        cbot122.start(),
        cbot123.start(),
        cbot124.start(),
        cbot125.start(),
        cbot126.start(),
        cbot127.start(),
        cbot128.start(),
        cbot129.start(),
        cbot130.start(),
        cbot131.start(),
        cbot132.start(),
        cbot133.start(),
        cbot134.start(),
        cbot135.start(),
        cbot136.start(),
        cbot137.start(),
        cbot138.start(),
        cbot139.start(),
        cbot140.start(),
        cbot141.start(),
        cbot142.start(),
        cbot143.start(),
        cbot144.start(),
        cbot145.start(),
        cbot146.start(),
        cbot147.start(),
        cbot148.start(),
        cbot149.start(),
        cbot150.start(),
        cbot151.start(),
        cbot152.start(),
        cbot153.start(),
        cbot154.start(),
        cbot155.start(),
        cbot156.start(),
        cbot157.start(),
        cbot158.start(),
        cbot159.start(),
        cbot160.start(),
        cbot161.start(),
        cbot162.start(),
        cbot163.start(),
        cbot164.start(),
        cbot165.start(),
        cbot166.start(),
        cbot167.start(),
        cbot168.start(),
        cbot169.start(),
        cbot170.start(),
        cbot171.start(),
        cbot172.start(),
        cbot173.start(),
        cbot174.start(),
        cbot175.start(),
        cbot176.start(),
        cbot177.start(),
        cbot178.start(),
        cbot179.start(),
        cbot180.start(),
        cbot181.start(),
        cbot182.start(),
        cbot183.start(),
        cbot184.start(),
        cbot185.start(),
        cbot186.start(),
        cbot187.start(),
        cbot188.start(),
        cbot189.start(),
        cbot190.start(),
        cbot191.start(),
        cbot192.start(),
        cbot193.start(),
        cbot194.start(),
        cbot195.start(),
        cbot196.start(),
        cbot197.start(),
        cbot198.start(),
        cbot199.start(),
        cbot200.start(),
        cbot201.start(),
        cbot202.start(),
        cbot203.start(),
        cbot204.start(),
        cbot205.start(),
        cbot206.start(),
        cbot207.start(),
        cbot208.start(),
        cbot209.start(),
        cbot210.start(),
        cbot211.start(),
        cbot212.start(),
        cbot213.start(),
        cbot214.start(),
        cbot215.start(),
        cbot216.start(),
        cbot217.start(),
        cbot218.start(),
        cbot219.start(),
        cbot220.start(),
        cbot221.start(),
        cbot222.start(),
        cbot223.start(),
        cbot224.start(),
        cbot225.start(),
        cbot226.start(),
        cbot227.start(),
        cbot228.start(),
        cbot229.start(),
        cbot230.start(),
        cbot231.start(),
        cbot232.start(),
        cbot233.start(),
        cbot234.start(),
        cbot235.start(),
        cbot236.start(),
        cbot237.start(),
        cbot238.start(),
        cbot239.start(),
        cbot240.start(),
        cbot241.start(),
        cbot242.start(),
        cbot243.start(),
        cbot244.start(),
        cbot245.start(),
        cbot246.start(),
        cbot247.start(),
        cbot248.start(),
        cbot249.start(),
        cbot250.start(),
        cbot251.start(),
        cbot252.start(),
        cbot253.start(),
        cbot254.start(),
        cbot255.start(),
        cbot256.start(),
        cbot257.start(),
        cbot258.start(),
        cbot259.start(),
        cbot260.start(),
        cbot261.start(),
        cbot262.start(),
        cbot263.start(),
        cbot264.start(),
        cbot265.start(),
        cbot266.start(),
        cbot267.start(),
        cbot268.start(),
        cbot269.start(),
        cbot270.start(),
        cbot271.start(),
        cbot272.start(),
        cbot273.start(),
        cbot274.start(),
        cbot275.start(),
        cbot276.start(),
        cbot277.start(),
        cbot278.start(),
        cbot279.start(),
        cbot280.start(),
        cbot281.start(),
        cbot282.start(),
        cbot283.start(),
        cbot284.start(),
        cbot285.start(),
        cbot286.start(),
        cbot287.start(),
        cbot288.start(),
        cbot289.start(),
        cbot290.start(),
        cbot291.start(),
        cbot292.start(),
        cbot293.start(),
        cbot294.start(),
        cbot295.start(),
        cbot296.start(),
        cbot297.start(),
        cbot298.start(),
        cbot299.start(),
        cbot300.start(),
        cbot301.start(),
        cbot302.start(),
        cbot303.start(),
        cbot304.start(),
        cbot305.start(),
        cbot306.start(),
        cbot307.start(),
        cbot308.start(),
        cbot309.start(),
        cbot310.start(),
        cbot311.start(),
        cbot312.start(),
        cbot313.start(),
        cbot314.start(),
        cbot315.start(),
        cbot316.start(),
        cbot317.start(),
        cbot318.start(),
        cbot319.start(),
        cbot320.start(),
        cbot321.start(),
        cbot322.start(),
        cbot323.start(),
        cbot324.start(),
        cbot325.start(),
        cbot326.start(),
        cbot327.start(),
        cbot328.start(),
        cbot329.start(),
        cbot330.start(),
        cbot331.start(),
        cbot332.start(),
        cbot333.start(),
        cbot334.start(),
        cbot335.start(),
        cbot336.start(),
        cbot337.start(),
        cbot338.start(),
        cbot339.start(),
        cbot340.start(),
        cbot341.start(),
        cbot342.start(),
        cbot343.start(),
        cbot344.start(),
        cbot345.start(),
        cbot346.start(),
        cbot347.start(),
        cbot348.start(),
        cbot349.start(),
        cbot350.start(),
        cbot351.start(),
        cbot352.start(),
        cbot353.start(),
        cbot354.start(),
        cbot355.start(),
        cbot356.start(),
        cbot357.start(),
        cbot358.start(),
        cbot359.start(),
        cbot360.start(),
        cbot361.start(),
        cbot362.start(),
        cbot363.start(),
        cbot364.start(),
        cbot365.start(),
        cbot366.start(),
        cbot367.start(),
        cbot368.start(),
        cbot369.start(),
        cbot370.start(),
        cbot371.start(),
        cbot372.start(),
        cbot373.start(),
        cbot374.start(),
        cbot375.start(),
        cbot376.start(),
        cbot377.start(),
        cbot378.start(),
        cbot379.start(),
        cbot380.start(),
        cbot381.start(),
        cbot382.start(),
        cbot383.start(),
        cbot384.start(),
        cbot385.start(),
        cbot386.start(),
        cbot387.start(),
        cbot388.start(),
        cbot389.start(),
        cbot390.start(),
        cbot391.start(),
        cbot392.start(),
        cbot393.start(),
        cbot394.start(),
        cbot395.start(),
        cbot396.start(),
        cbot397.start(),
        cbot398.start(),
        cbot399.start(),
        cbot400.start(),
        cbot401.start(),
        cbot402.start(),
        cbot403.start(),
        cbot404.start(),
        cbot405.start(),
        cbot406.start(),
        cbot407.start(),
        cbot408.start(),
        cbot409.start(),
        cbot410.start(),
        cbot411.start(),
        cbot412.start(),
        cbot413.start(),
        cbot414.start(),
        cbot415.start(),
        cbot416.start(),
        cbot417.start(),
        cbot418.start(),
        cbot419.start(),
        cbot420.start(),
        cbot421.start(),
        cbot422.start(),
        cbot423.start(),
        cbot424.start(),
        cbot425.start(),
        cbot426.start(),
        cbot427.start(),
        cbot428.start(),
        cbot429.start(),
        cbot430.start(),
        cbot431.start(),
        cbot432.start(),
        cbot433.start(),
        cbot434.start(),
        cbot435.start(),
        cbot436.start(),
        cbot437.start(),
        cbot438.start(),
        cbot439.start(),
        cbot440.start(),
        cbot441.start(),
        cbot442.start(),
        cbot443.start(),
        cbot444.start(),
        cbot445.start(),
        cbot446.start(),
        cbot447.start(),
        cbot448.start(),
        cbot449.start(),
        cbot450.start(),
        cbot451.start(),
        cbot452.start(),
        cbot453.start(),
        cbot454.start(),
        cbot455.start(),
        cbot456.start(),
        cbot457.start(),
        cbot458.start(),
        cbot459.start(),
        cbot460.start(),
        cbot461.start(),
        cbot462.start(),
        cbot463.start(),
        cbot464.start(),
        cbot465.start(),
        cbot466.start(),
        cbot467.start(),
        cbot468.start(),
        cbot469.start(),
        cbot470.start(),
        cbot471.start(),
        cbot472.start(),
        cbot473.start(),
        cbot474.start(),
        cbot475.start(),
        cbot476.start(),
        cbot477.start(),
        cbot478.start(),
        cbot479.start(),
        cbot480.start(),
        cbot481.start(),
        cbot482.start(),
        cbot483.start(),
        cbot484.start(),
        cbot485.start(),
        cbot486.start(),
        cbot487.start(),
        cbot488.start(),
        cbot489.start(),
        cbot490.start(),
        cbot491.start(),
        cbot492.start(),
        cbot493.start(),
        cbot494.start(),
        cbot495.start(),
        cbot496.start(),
        cbot497.start(),
        cbot498.start(),
        cbot499.start(),
        cbot500.start(),
        cbot501.start(),
        cbot502.start(),
        cbot503.start(),
        cbot504.start(),
        cbot505.start(),
        cbot506.start(),
        cbot507.start(),
        cbot508.start(),
        cbot509.start(),
        cbot510.start(),
        cbot511.start(),
        cbot512.start(),
        cbot513.start(),
        cbot514.start(),
        cbot515.start(),
        cbot516.start(),
        cbot517.start(),
        cbot518.start(),
        cbot519.start(),
        cbot520.start(),
        cbot521.start(),
        cbot522.start(),
        cbot523.start(),
        cbot524.start(),
        cbot525.start(),
        cbot526.start(),
        cbot527.start(),
        cbot528.start(),
        cbot529.start(),
        cbot530.start(),
        cbot531.start(),
        cbot532.start(),
        cbot533.start(),
        cbot534.start(),
        cbot535.start(),
        cbot536.start(),
        cbot537.start(),
        cbot538.start(),
        cbot539.start(),
        cbot540.start(),
        cbot541.start(),
        cbot542.start(),
        cbot543.start(),
        cbot544.start(),
        cbot545.start(),
        cbot546.start(),
        cbot547.start(),
        cbot548.start(),
        cbot549.start(),
        cbot550.start(),
        cbot551.start(),
        cbot552.start(),
        cbot553.start(),
        cbot554.start(),
        cbot555.start(),
        cbot556.start(),
        cbot557.start(),
        cbot558.start(),
        cbot559.start(),
        cbot560.start(),
        cbot561.start(),
        cbot562.start(),
        cbot563.start(),
        cbot564.start(),
        cbot565.start(),
        cbot566.start(),
        cbot567.start(),
        cbot568.start(),
        cbot569.start(),
        cbot570.start(),
        cbot571.start(),
        cbot572.start(),
        cbot573.start(),
        cbot574.start(),
        cbot575.start(),
        cbot576.start(),
        cbot577.start(),
        cbot578.start(),
        cbot579.start(),
        cbot580.start(),
        cbot581.start(),
        cbot582.start(),
        cbot583.start(),
        cbot584.start(),
        cbot585.start(),
        cbot586.start(),
        cbot587.start(),
        cbot588.start(),
        cbot589.start(),
        cbot590.start(),
        cbot591.start(),
        cbot592.start(),
        cbot593.start(),
        cbot594.start(),
        cbot595.start(),
        cbot596.start(),
        cbot597.start(),
        cbot598.start(),
        cbot599.start(),
        cbot600.start(),
        cbot601.start(),
        cbot602.start(),
        cbot603.start(),
        cbot604.start(),
        cbot605.start(),
        cbot606.start(),
        cbot607.start(),
        cbot608.start(),
        cbot609.start(),
        cbot710.start(),
        cbot711.start(),
        cbot712.start(),
        cbot713.start(),
        cbot714.start(),
        cbot715.start(),
        cbot716.start(),
        cbot717.start(),
        cbot718.start(),
        cbot719.start(),
        cbot720.start(),
        cbot721.start(),
        cbot722.start(),
        cbot723.start(),
        cbot724.start(),
        cbot725.start(),
        cbot726.start(),
        cbot727.start(),
        cbot728.start(),
        cbot729.start(),
        cbot730.start(),
        cbot731.start(),
        cbot732.start(),
        cbot733.start(),
        cbot734.start(),
        cbot735.start(),
        cbot736.start(),
        cbot737.start(),
        cbot738.start(),
        cbot739.start(),
        cbot740.start(),
        cbot741.start(),
        cbot742.start(),
        cbot743.start(),
        cbot744.start(),
        cbot745.start(),
        cbot746.start(),
        cbot747.start(),
        cbot748.start(),
        cbot749.start(),
        cbot750.start(),
        cbot751.start(),
        cbot752.start(),
        cbot753.start(),
        cbot754.start(),
        cbot755.start(),
        cbot756.start(),
        cbot757.start(),
        cbot758.start(),
        cbot759.start(),
        cbot760.start(),
        cbot761.start(),
        cbot762.start(),
        cbot763.start(),
        cbot764.start(),
        cbot765.start(),
        cbot766.start(),
        cbot767.start(),
        cbot768.start(),
        cbot769.start(),
        cbot770.start(),
        cbot771.start(),
        cbot772.start(),
        cbot773.start(),
        cbot774.start(),
        cbot775.start(),
        cbot776.start(),
        cbot777.start(),
        cbot778.start(),
        cbot779.start(),
        cbot780.start(),
        cbot781.start(),
        cbot782.start(),
        cbot783.start(),
        cbot784.start(),
        cbot785.start(),
        cbot786.start(),
        cbot787.start(),
        cbot788.start(),
        cbot789.start(),
        cbot790.start(),
        cbot791.start(),
        cbot792.start(),
        cbot793.start(),
        cbot794.start(),
        cbot795.start(),
        cbot796.start(),
        cbot797.start(),
        cbot798.start(),
        cbot799.start(),
        cbot790.start(),
        cbot791.start(),
        cbot792.start(),
        cbot793.start(),
        cbot794.start(),
        cbot795.start(),
        cbot796.start(),
        cbot797.start(),
        cbot798.start(),
        cbot799.start(),
        cbot800.start(),
        cbot801.start(),
        cbot802.start(),
        cbot803.start(),
        cbot804.start(),
        cbot805.start(),
        cbot806.start(),
        cbot807.start(),
        cbot808.start(),
        cbot809.start(),
        cbot810.start(),
        cbot811.start(),
        cbot812.start(),
        cbot813.start(),
        cbot814.start(),
        cbot815.start(),
        cbot816.start(),
        cbot817.start(),
        cbot818.start(),
        cbot819.start(),
        cbot820.start(),
        cbot821.start(),
        cbot822.start(),
        cbot823.start(),
        cbot824.start(),
        cbot825.start(),
        cbot826.start(),
        cbot827.start(),
        cbot828.start(),
        cbot829.start(),
        cbot930.start(),
        cbot931.start(),
        cbot932.start(),
        cbot933.start(),
        cbot934.start(),
        cbot935.start(),
        cbot936.start(),
        cbot937.start(),
        cbot938.start(),
        cbot939.start(),
        cbot930.start(),
        cbot941.start(),
        cbot942.start(),
        cbot943.start(),
        cbot944.start(),
        cbot945.start(),
        cbot946.start(),
        cbot947.start(),
        cbot948.start(),
        cbot949.start(),
        cbot950.start(),
        cbot951.start(),
        cbot952.start(),
        cbot953.start(),
        cbot954.start(),
        cbot955.start(),
        cbot956.start(),
        cbot957.start(),
        cbot958.start(),
        cbot959.start(),
        cbot960.start(),
        cbot961.start(),
        cbot962.start(),
        cbot963.start(),
        cbot964.start(),
        cbot965.start(),
        cbot966.start(),
        cbot967.start(),
        cbot968.start(),
        cbot969.start(),
        cbot960.start(),
        cbot971.start(),
        cbot972.start(),
        cbot973.start(),
        cbot974.start(),
        cbot975.start(),
        cbot976.start(),
        cbot977.start(),
        cbot978.start(),
        cbot979.start(),
        cbot970.start(),
        cbot981.start(),
        cbot982.start(),
        cbot983.start(),
        cbot984.start(),
        cbot985.start(),
        cbot986.start(),
        cbot987.start(),
        cbot988.start(),
        cbot989.start(),
        cbot990.start(),
        cbot991.start(),
        cbot992.start(),
        cbot993.start(),
        cbot994.start(),
        cbot995.start(),
        cbot996.start(),
        cbot997.start(),
        cbot998.start(),
        cbot999.start()
        )


asyncio.run(main())
