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
            uc = int(input("{x} * {y} = ".format(x=a, y=b)))
            if uc == c:
                return "You're God Damn right!"
            elif uc != c:
                return "No, right answer is {z}".format(z=c)
        except ValueError:
            return "You typed not a number!"
    elif mode == 'telegram':
        obj.sendmsg("{x} * {y} = ?".format(x=a, y=b))
        try:
            uc = int(obj.readlm)
            if uc == c:
                return "You're God Damn right!"
            elif uc != c:
                return "No, right answer is {answ}".format(answ=c)
        except:
            obj.readmsg()


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
                return "No, right answer is {answ} with residual of {resid}".format(answ=c1, resid=c2)
        except ValueError:
            return "You typed not a number!"
    elif mode == 'telegram':
        obj.sendmsg("{x} * {y} = ?".format(x=a, y=b))
        try:
            uc1 = int(obj.readlm)
            uc2 = int(obj.readlm)
            if uc1 == c1 and uc2 == c2:
                return "You're God Damn right!"
            elif uc1 != c1 or uc2 != c2:
                return "No, right answer is {answ} with residual of {resid}".format(answ=c1, resid=c2)
        except:
            obj.readmsg()
