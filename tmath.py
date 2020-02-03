import time
import re
import random
import asyncio


import numpy as np



if __name__ == "__main__":
    print("It is math module, not a standalone program!")


async def ml(multiplicand, multiplier, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
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
    c = a * b

    # bot won't ask equation with the same answer, for novelty check
    if c in obj.c:
        await ml(multiplicand, multiplier, obj=obj)
    else:
        obj.c.add(c)  # add answer if unique

    await obj.sendmsg(f"{a} * {b} = ?")

    while True:

        await asyncio.sleep(obj.timeout)
        await obj.readmsg()
        
        if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
            await obj.restart()

        try:
            uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\'", obj.readlm)
            uc = int(str(uc.group(1)))
        except:
            continue

        if uc in obj.uc:  # if user answer is in list then it's old
            continue  # wait for new message
        else:
            obj.uc.add(uc)  # add user answer if unique
            if uc == c:
                await obj.sendmsg("You're God Damn right!")
                break
            elif uc != c:
                await obj.sendmsg(f"No, right answer is {c}!")
                break


async def dl(dividend, divider, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
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

    # bot won't ask equation with the same answer, for novelty check
    if c1 in obj.c1 or c2 in obj.c2:
        await dl(dividend, divider, obj=obj)
    else:
        obj.c1.add(c1)  # add answer if unique
        obj.c2.add(c2)  # add residual if unique
    
    await obj.sendmsg(f"{a} // | % {b} = ?")
    
    while True:

        await asyncio.sleep(obj.timeout)
        await obj.readmsg()

        if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
            await obj.restart()

        try:
            uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
            uc1, uc2 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2)])
        except:
            continue

        if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
            continue  # wait for new message
        else:
            obj.uc1.add(uc1)  # add user answer if unique
            obj.uc2.add(uc2)  # add user residual if unique
            if uc1 == c1 and uc2 == c2:
                await obj.sendmsg("You're God Damn right!")
                break
            else:
                await obj.sendmsg(f"No, right answer is {c1} with residual of {c2}!")
                break


async def vml(multiplicand, multiplier, matrix=2, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
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

    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    
    if matrix == 2:
        
        a = np.matrix([[a1, b1],
                       [a2, b2]])
        
        b = np.matrix([[l1],
                       [l2]])
    
    elif matrix == 3:
        
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

    elif matrix == 2.5:
        choices = [ "2x3", "3x2" ]
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

    if matrix == 2 or matrix == 2.5 and fch == "2x3":
        
        c1, c2 = map(lambda x: int(x), [c[0], c[1]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2:
            await vml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c2)  # add answer if unique
            obj.c2.add(c2)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                continue  # wait for new message
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                if uc1 == c1 and uc2 == c2:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}!")
                    break

    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
        
        c1, c2, c3 = map(lambda x: int(x), [c[0], c[1], c[2]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2 or c3 in obj.c3:
            await mml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answer if unique
            obj.c2.add(c2)
            obj.c3.add(c3)


        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()

            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2 or uc3 in obj.uc3:  # if user answers are in lists, then they're old
                continue  # wait for new message
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                if uc1 == c1 and uc2 == c2 and uc3 == c3:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}!")
                    break


async def mml(multiplicand, multiplier, matrix=2, obj=None):
    x1, x2 = 1, 1
    y1, y2 = 1, 1
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

    a1 = random.randint(x1, y1)
    a2 = random.randint(x1, y1)
    b1 = random.randint(x1, y1)
    b2 = random.randint(x1, y1)
    l1 = random.randint(x2, y2)
    l2 = random.randint(x2, y2)
    q1 = random.randint(x2, y2)
    q2 = random.randint(x2, y2)
    
    if matrix == 2:
        
        a = np.matrix([[a1, b1],
                       [a2, b2]])

        b = np.matrix([[l1, q1],
                       [l2, q2]])

    elif matrix == 3:
        
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

    elif matrix == 2.5:

        choices = [ "2x3", "3x2" ]
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

    if matrix == 2 or matrix == 2.5 and fch == "2x3":
        
        c1, c2, c3, c4 = map(lambda x: int(x), [c[0, 0], c[0, 1], c[1, 0], c[1, 1]])

        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2:
            await mml(multiplicand, multiplier, obj=obj)
        elif c3 in obj.c3 or c4 in obj.c4:
            await mml(multiplicand, multiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answer if unique
            obj.c2.add(c2)
            obj.c3.add(c3)
            obj.c4.add(c4)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()
            
            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3, uc4 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3), uc.group(4)])
            except:
                continue
            
            if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                continue  # wait for new message 
            elif uc3 in obj.uc3 or uc4 in obj.uc4:
                continue
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                obj.uc4.add(uc4)

                if uc1 == c1 and uc2 == c2 and uc3 == c3 and uc4 == c4:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}, {c4}")
                    break

    elif matrix == 3 or matrix == 2.5 and fch == "3x2":
        
        c1, c2, c3 = map(lambda x: int(x), [c[0, 0], c[0, 1], c[0, 2]])
        c4, c5, c6 = map(lambda x: int(x), [c[1, 0], c[1, 1], c[1, 2]])
        c7, c8, c9 = map(lambda x: int(x), [c[2, 1], c[2, 1], c[2, 2]])
        
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2 or c3 in obj.c3:
            await mml(multiplicand, multiplier, obj=obj)
        elif c4 in obj.c4 or c5 in obj.c5 or c6 in obj.c6:
            await mml(multiplicand, miltiplier, obj=obj)
        else:
            obj.c1.add(c1)  # add answers if unique
            obj.c2.add(c2)
            obj.c3.add(c3)
            obj.c4.add(c4)
            obj.c5.add(c5)
            obj.c6.add(c6)
            obj.c7.add(c7)
            obj.c8.add(c8)
            obj.c9.add(c9)

        await obj.sendmsg(f"{a}\n*\n{b}\n= ?")

        while True:

            await asyncio.sleep(obj.timeout)
            await obj.readmsg()

            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                await obj.restart()

            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10}),\s([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1, uc2, uc3 = map(lambda x: int(str(x)), [uc.group(1), uc.group(2), uc.group(3)])
                uc4, uc5, uc6 = map(lambda x: int(str(x)), [uc.group(4), uc.group(5), uc.group(6)])
                uc7, uc8, uc9 = map(lambda x: int(str(x)), [uc.group(7), uc.group(8), uc.group(9)])
            except:
                continue

            if uc1 in obj.uc1 or uc2 in obj.uc2 or uc3 in obj.uc3:  # if user answers are in lists, then they're old
                continue  # wait for new message
            elif uc4 in obj.uc4 or uc5 in obj.uc5 or uc6 in obj.uc6: 
                continue
            elif uc7 in obj.uc7 or uc8 in obj.uc8 or uc9 in obj.uc9: 
                continue
            else:
                obj.uc1.add(uc1)
                obj.uc2.add(uc2)
                obj.uc3.add(uc3)
                obj.uc4.add(uc4)
                obj.uc5.add(uc5)
                obj.uc6.add(uc6)
                obj.uc7.add(uc7)
                obj.uc8.add(uc8)
                obj.uc9.add(uc9)
                if uc1 == c1 and uc2 == c2 and uc3 == c3:
                    await obj.sendmsg("You're God Damn right!")
                    break
                else:
                    await obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}, {c4}, {c5}, {c6}, {c7}, {c8}, {c9}!")
                    break
