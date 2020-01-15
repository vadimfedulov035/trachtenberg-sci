from tmath import ml, dl

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
    num = [ 2, 1 ]
    if endl == "yes":
        while True:
            if itera % (rpass * 2) == 1 and itera != 1:
                num[0] += 1
            elif itera % rpass == 1 and itera != 1:
                num[1] += 1
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
                num[0] += 1
            elif itera % rpass == 1 and itera != 1:
                num[1] += 1
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
