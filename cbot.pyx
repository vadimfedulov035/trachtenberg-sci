import re
import json
import itertools
import urllib.request
import urllib.parse
import urllib.error
import asyncio
import numpy as np


with open("tok.conf", "r") as r:
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
        if o.rdlm == "/restart":  # check for restart command
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
        if o.rdlm == "/restart":  # check for restart command
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
        if o.rdlm == "/restart":  # check for restart command
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
        if o.rdlm == "/restart":  # check for restart m
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
            if o.rdlm == "/restart":  # check for restart m
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
            if o.rdlm == "/restart":  # check for restart m
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
            if o.rdlm == "/restart":  # check for restart m
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
            if o.rdlm == "/restart":  # check for restart m
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
    cdef public double TIMEOUT
    """define message urls and message variables"""
    cdef public str URL, URLR, ERROR_EN, ERROR_RU, MISTYPE_EN, MISTYPE_RU
    """define right answers and user-supplied ones"""
    cdef public int c, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cdef public int u, u1, u2, u3, u4, u5, u6, u7, u8, u9
    """define all messages and message related variables"""
    cdef public str m, m1, m2, m3, m4, m5, prevm, rdlm
    cdef public int mc1, mc2, mc3, mc4, mc5, diffch
    """define all mode and mode of count related variables"""
    cdef public list r, mnum, dnum, vmnum, mmnum
    cdef public int sqnum, ronum
    cdef public int st, n1, n2
    """define restart variable and convertion ones for different modes"""
    cdef public int resch, cmul, cdiv, csqr, croot, cvmul, cmmul
    """define all time related variables"""
    cdef public int date, ldate
    """define all choice related variables"""
    cdef public str lang, mode
    cdef public int s, d, ms

    def __init__(object self, str tok, int num):
        """static variables are defined here for correct start up"""
        self.TOKEN = tok  # try token for connection to API
        self.NUMBER = num  # num serves as enumerator of cid later
        self.TIMEOUT = 0.0001  # serves as placeholder for switching
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
        self.mc1 = False
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

    async def rdf(object self):
        """read cids from log file for finding right CID"""
        with open("cids.log", "r") as f:
            cids = f.read().rstrip().split("\n")
            self.CID = cids[self.NUMBER]

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
        while True:
            try:
                await self.rdf()  # get CID
                break
            except IndexError:
                await asyncio.sleep(self.TIMEOUT)
                continue
        while True:
            try:
                await self.rdm()  # get latest message
            except ConnectionError:
                continue
            if self.rdlm == "/restart":
                await self.restart()  # check for restart command
            if not self.mc1:
                self.mc1 = True
                if self.rdlm == "/start" or self.resch:
                    self.m1 = "Started setting up! Type /restart if you want to restart today! "
                    self.m2 = "Type /start when want to start again next day after 21:00 MSK! "
                    self.m3 = "Please, choose language! (/en, /ru)"
                    self.m = self.m1 + self.m2 + self.m3
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
            if self.rdlm == "/restart":
                await self.restart()  # check for restart command
            if not self.mc2:
                if self.lang == "en":
                    self.m1 = "Do you want a linear algebra operations: "
                    self.m2 = "matrix, vector-matrix multiplication; "
                    self.m3 = "arithmetics operations: multiplication, "
                    self.m4 = "division, squaring, taking square root? "
                elif self.lang == "ru":
                    self.m1 = "Вы хотите операции линейной алгебры: "
                    self.m2 = "матричное, векторно-матричное умножение; "
                    self.m3 = "арифметические операциии: умножение, деление, "
                    self.m4 = "возведение в квадрат, взятие квадратного корня? "
                self.m5 = "(/mmul, /vmul, /mul, /div, /sqr, /root)"
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
            if self.rdlm == "/restart":
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
            if self.rdlm == "/restart":
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
            if self.rdlm == "/restart":
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
