import tsmath as sm  # import math library for handling math operations



mnum = [ 2, 1 ]
dnum = [ 4, 2 ]
mmnum = [ 1, 2 ]
itera = 1


answ = input("Do you want a matrix multiplication, simple multiplication or simple division test? (mmul, mul, div): ")
try:
    rpass = int(input("How many iterations do you want before increasing difficulty? (num): "))
except ValueError:
    print("You typed not a number!")

answ.lower()


if answ == "mul":
    while True:
        if rpass ==1:
            if itera != 1:
                if itera % 2 == 1:
                    mnum[0] += 1
                else:
                    mnum[1] += 1
        else:
            if itera % (rpass * 2) == 1 and itera != 1:
                mnum[0] += 1
            elif itera % rpass == 1 and itera != 1:
                mnum[1] += 1

        sm.ml(mnum[0], mnum[1])
        itera += 1

elif answ == "div":
    while True:
        if rpass == 1:
            if itera != 1:
                if itera % 2 == 1:
                    dnum[1] += 1
                else:
                    dnum[0] += 1
        else:
            if itera % (rpass * 2) == 1 and itera != 1:
                dnum[1] += 1
            elif itera % rpass == 1 and itera != 1:
                dnum[0] += 1

        sm.dl(dnum[0], dnum[1])
        itera += 1

elif answ == "mmul":
    while True:
        if rpass == 1:
            if itera != 1:
                if itera % 2 == 1:
                    mmnum[1] += 1
                else:
                    mmnum[0] += 1
        else:
            if itera % (rpass * 2) == 1 and itera != 1:
                mmnum[1] += 1
            elif itera % rpass == 1 and itera != 1:
                mmnum[0] += 1

        sm.mml(mmnum[0], mmnum[1])
        itera += 1

else:
    print("You chose nothing!")
