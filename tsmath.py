import time
import re
import random
import numpy as np


if __name__ == "__main__":
    print("It is math module, not a standalone program!")


def ml(multiplicand, multiplier, mode="standalone", obj=None):
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
    
    if mode == 'standalone':
        try:
            uc = int(input(f"{a} * {b} = "))
            if uc == c:
                print("You're God Damn right!")
            elif uc != c:
                print(f"No, right answer is {c}")
        except ValueError:
            print("You typed not a number!")
    
    elif mode == 'telegram':
        # bot won't ask equation with the same answer, for novelty check
        if c in obj.c:
            ml(multiplicand, multiplier, mode=mode, obj=obj)
        else:
            obj.c.add(c)  # add answer if unique
        obj.sendmsg(f"{a} * {b} = ")
        while True:
            time.sleep(obj.timeout)
            obj.readmsg()
            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                obj.restart()
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
                    obj.sendmsg("You're God Damn right!")
                    break
                elif uc != c:
                    obj.sendmsg(f"No, right answer is {c}")
                    break


def dl(dividend, divider, mode="standalone", obj=None):
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
    
    if mode == 'standalone':
        try:
            uc1 = int(input(f"{a} // {b} = "))
            uc2 = int(input(f"{a} % {b} = "))
            if uc1 == c1 and uc2 == c2:
                print("You're God Damn right!")
            elif uc1 != c1 or uc2 != c2:
                print(f"No, right answer is {c1} with residual of {c2}")
        except ValueError:
            print("You typed not a number!")
    
    elif mode == 'telegram':
        # bot won't ask equation with the same answer, for novelty check
        if c1 in obj.c1 or c2 in obj.c2:
            dl(multiplicand, multiplier, mode=mode, obj=obj)
        else:
            obj.c1.add(c1)  # add answer if unique
            obj.c2.add(c2)  # add residual if unique
        obj.sendmsg(f"{a} // | % {b} = ")
        while True:
            time.sleep(obj.timeout)
            obj.readmsg()
            if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                obj.restart()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                uc1 = int(str(uc.group(1)))
                uc2 = int(str(uc.group(2)))
            except:
                continue
            if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                continue  # wait for new message
            else:
                obj.uc1.add(uc1)  # add user answer if unique
                obj.uc2.add(uc2)  # add user residual if unique
                if uc1 == c1 and uc2 == c2:
                    obj.sendmsg("You're God Damn right!")
                    break
                else:
                    obj.sendmsg(f"No, right answer is {c1} with residual of {c2}")
                    break


def mml(multiplicand, multiplier, mode="standalone", matrix=2, obj=None):
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
    if matrix == 2:
        a1 = random.randint(x1, y1)
        a2 = random.randint(x1, y1)
        b1 = random.randint(x1, y1)
        b2 = random.randint(x1, y1)
        c1 = random.randint(x2, y2)
        c2 = random.randint(x2, y2)
        a = np.matrix([[a1, b1],
                       [a2, b2]])
        b = np.matrix([[c1],
                       [c2]])
        c = np.matmul(a, b)
    elif matrix == 3:
        a1 = random.randint(x1, y1)
        a2 = random.randint(x1, y1)
        a3 = random.randint(x1, y1)
        b1 = random.randint(x1, y1)
        b2 = random.randint(x1, y1)
        b3 = random.randint(x1, y1)
        c1 = random.randint(x1, y1)
        c2 = random.randint(x1, y1)
        c3 = random.randint(x1, y1)
        d1 = random.randint(x2, y2)
        d2 = random.randint(x2, y2)
        d3 = random.randint(x2, y2)
        a = np.matrix([[a1, b1, c1],
                       [a2, b2, c2],
                       [a3, b3, c3]])
        b = np.matrix([[d1],
                       [d2],
                       [d3]])
        c = np.matmul(a, b)
        
    if mode == "standalone":
        print(f"{a}\n*\n{b}\n= ?")
        try:
            uc1 = int(input("Answer: "))
            uc2 = int(input("Answer: "))
        except ValueError:
            print("You typed not a number!")
        if int(c[0]) == int(uc1) and int(c[1]) == int(uc2):
            print("You'r God Damn Right")
        else:
            print("No, right answer is: ")
            print(c)
    elif mode == "telegram":
        if matrix == 2:
            c1 = int(c[0])
            c2 = int(c[1])
            # bot won't ask equation with the same answer, for novelty check
            if c1 in obj.c1 or c2 in obj.c2:
                mml(multiplicand, multiplier, mode=mode, obj=obj)
            else:
                obj.c1.add(c2)  # add answer if unique
                obj.c2.add(c2)  # add answer if unique
            obj.sendmsg(f"{a}\n*\n{b}\n= ?")

            while True:
                time.sleep(obj.timeout)
                obj.readmsg()
                if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                    obj.restart()
                try:
                    uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                    uc1 = int(str(uc.group(1)))
                    uc2 = int(str(uc.group(2)))
                except:
                    continue
                if uc1 in obj.uc1 or uc2 in obj.uc2:  # if user answers are in lists, then they're old
                    continue  # wait for new message
                else:
                    obj.uc1.add(uc1)  # add user answer if unique
                    obj.uc2.add(uc2)  # add user residual if unique
                    if uc1 == c1 and uc2 == c2:
                        obj.sendmsg("You're God Damn right!")
                        break
                    else:
                        obj.sendmsg(f"No, right answer is {c1}, {c2}")
                        break
        elif matrix == 3:
            c1 = int(c[0])
            c2 = int(c[1])
            c3 = int(c[2])
            # bot won't ask equation with the same answer, for novelty check
            if c1 in obj.c1 or c2 in obj.c2 or c3 in obj.c3:
                mml(multiplicand, multiplier, mode=mode, obj=obj)
            else:
                obj.c1.add(c2)  # add answer if unique
                obj.c2.add(c2)  # add answer if unique
                obj.c3.add(c3)  # add answer if unique

            obj.sendmsg(f"{a}\n*\n{b}\n= ?")

            while True:
                time.sleep(obj.timeout)
                obj.readmsg()
                if re.search(r"\'text\'\:\s\'\/restart\'", obj.readlm):
                    obj.restart()
                try:
                    uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\,\s([0-9]{1,10})\,\s([0-9]{1,10})\'", obj.readlm)
                    uc1 = int(str(uc.group(1)))
                    uc2 = int(str(uc.group(2)))
                    uc3 = int(str(uc.group(3)))
                except:
                    continue
                if uc1 in obj.uc1 or uc2 in obj.uc2 or uc3 in obj.uc3:  # if user answers are in lists, then they're old
                    continue  # wait for new message
                else:
                    obj.uc1.add(uc1)  # add user answer if unique
                    obj.uc2.add(uc2)  # add user answer if unique
                    obj.uc3.add(uc3)  # add user answer if unique
                    if uc1 == c1 and uc2 == c2 and uc3 == c3: 
                        obj.sendmsg("You're God Damn right!")
                        break
                    else:
                        obj.sendmsg(f"No, right answer is {c1}, {c2}, {c3}")
                        break
