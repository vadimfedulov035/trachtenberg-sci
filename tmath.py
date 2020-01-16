import time
import re
import random



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
            uc = int(input("{} * {} = ".format(a, b)))
            if uc == c:
                return "You're God Damn right!"
            elif uc != c:
                return "No, right answer is {}".format(c)
        except ValueError:
            return "You typed not a number!"
    elif mode == 'telegram':
        if c in obj.c:
            ml(multiplicand, multiplier, mode=mode, obj=obj)
        else:
            obj.c.append(c)
        obj.sendmsg("{} * {} = ".format(a, b))
        while True:
            time.sleep(obj.timeout)
            obj.readmsg()
            try:
                uc = re.search(r"\'text\'\:\s\'([0-9]{1,10})\'", obj.readlm)
                uc = int(str(uc.group(1)))
            except:
                continue
            if uc in obj.uc:
                continue
            else:
                obj.uc.append(uc)
                if uc == c:
                    obj.sendmsg("You're God Damn right!")
                    break
                elif uc != c:
                    obj.sendmsg("No, right answer is {}".format(c))
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
            uc1 = int(input("{} // {} = ".format(a, b)))
            uc2 = int(input("{} % {} = ".format(a, b)))
            if uc1 == c1 and uc2 == c2:
                return "You're God Damn right!"
            elif uc1 != c1 or uc2 != c2:
                obj.sendmsg("{} * {} = ?".format(a, b))
                return "No, right answer is {} with residual of {}".format(c1, c2)
        except ValueError:
            return "You typed not a number!"
    elif mode == 'telegram':
        if c1 in obj.c1 or c2 in obj.c2:
            dl(multiplicand, multiplier, mode=mode, obj=obj)
        else:
            obj.c1.append(c1)
            obj.c2.append(c2)
        obj.sendmsg("{} // {} = ".format(a, b))
        while True:
            time.sleep(obj.timeout)
            obj.readmsg()
            try:
                uc1 = re.search(r"\'text\'\:\s\'([0-9]{1,10})\'", obj.readlm)
                uc1 = int(str(uc1.group(1)))
            except:
                continue
            if uc1 in obj.uc1:
                continue
            else: 
                obj.uc1.append(uc1)
                break
        obj.sendmsg("{} % {} = ".format(a, b))
        while True:
            time.sleep(obj.timeout)
            obj.readmsg()
            try:
                uc2 = re.search(r"\'text\'\:\s\'([0-9]{1,10})\'", obj.readlm)
                uc2 = int(str(uc2.group(1)))
            except:
                continue
            if uc2 in obj.uc2:
                continue
            else:
                obj.uc2.append(uc2)
                if uc1 == c1 and uc2 == c2:
                    obj.sendmsg("You're God Damn right!")
                    break
                elif uc1 != c1 or uc2 != c2: 
                    obj.sendmsg("No, right answer is {} with residual of {}".format(c1, c2))
                    break
