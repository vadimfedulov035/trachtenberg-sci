from tmath import ml, dl

answ = input("Do you want a division test or multiplication? (mul/div): ")
try:
    rpass = int(input("How many iterations do you want before increasing difficulty? (num): "))
except ValueError:
    print("You typed not a number!")

answ.lower()

itera = 1
if answ == "mul":
    num = [ 2, 1 ]
    while True:
        if itera % (rpass * 2) == 1 and itera != 1:
            num[0] += 1
        elif itera % rpass == 1 and itera != 1:
            num[1] += 1
        print(ml(num[0], num[1]))
        itera += 1
elif answ == "div":
    num = [ 4, 2 ]
    while True:
        if itera % (rpass * 2) == 1 and itera != 1:
            num[1] += 1
        elif itera % rpass == 1 and itera != 1:
            num[0] += 1
        print(dl(num[0], num[1]))
        itera += 1
else:
    print("You chose nothing!")
