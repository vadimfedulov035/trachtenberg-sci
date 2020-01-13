import random



def ml(multiplicand, multiplier):
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
    try:
        uc = int(input("{} * {} = ".format(a, b)))
        if uc == c:
            return "You're God Damn right!"
        elif uc != c:
            return "No, right answer is {}".format(c)
    except ValueError:
        return "You typed not a number!"

def dl(dividend, divider):
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
    try:    
        uc1 = int(input("{} // {} = ".format(a, b)))
        uc2 = int(input("{} % {} = ".format(a, b)))
        if uc1 == c1 and uc2 == c2:
            return "You're God Damn right!"
        elif uc1 != c1 or uc2 != c2:
            return "No, right answer is {} with residual of {}".format(c1, c2)
    except ValueError:
        return "You typed not a number!"

answ = input("Do you want a division test or multiplication? (mul/div): ")
endl = input("Do you want to be in endless mathematical loop? (yes/no): ")
try:
    rpass = int(input("How many iterations do you want before increasing difficulty? (num): "))
except ValueError:
    print("You typed not a number!")

answ.lower()
endl.lower()

itera = 1
if answ == "mul":
    num = [ 2, 2 ]
    if endl == "yes":
        while True:
            if itera % (rpass * 2) == 1 and itera != 1:
                num[1] += 1
            elif itera % rpass == 1 and itera != 1:
                num[0] += 1
            print(ml(num[0], num[1]))
            itera += 1
    elif endl == "no":
        try:
            nitera = int(input("How many iterations do you want to pass?: "))
        except ValueError:
            print("You typed not a number!")
        while True:
            if nitera == itera:
                break
            if itera % (rpass * 2) == 1 and itera != 1:
                num[1] += 1
            elif itera % rpass == 1 and itera != 1:
                num[0] += 1
            print(ml(num[0], num[1]))
            itera += 1
    else:
        print("You typed neither yes, neither no!")
elif answ == "div":
    num = [ 4, 2 ]
    if endl == "yes":
        while True:
            if itera % (rpass * 2) == 1 and itera != 1:
                num[1] += 1
            elif itera % rpass == 1 and itera != 1:
                num[0] += 1
            print(dl(num[0], num[1]))
            itera += 1
    elif endl == "no":
        try:
            nitera = int(input("How many iterations do you want to pass?: "))
        except ValueError:
            print("You typed not a number!")
        while True:
            if nitera == itera:
                break
            if itera % (rpass * 2) == 1 and itera != 1:
                num[1] += 1
            elif itera % rpass == 1 and itera != 1:
                num[0] += 1
            print(dl(num[0], num[1]))
            itera += 1
    else:
        print("You typed neither yes, neither no!")
else:
    print("You chose nothing!")
