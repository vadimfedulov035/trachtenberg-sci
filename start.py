#!/usr/bin/env python3.7
import asyncio
from bot import Bot


with open("tok.conf", "r") as config:
    token = config.read().split("|")[1]

nbot = 0

while True:
    try:
        pbot1 = Bot(token, 0)
        nbot += 1
    except IndexError:
        print("No users yet")
        continue
    try:
        pbot2 = Bot(token, 1)
        nbot += 1
    except IndexError:
        break
    try:
        pbot3 = Bot(token, 2)
        nbot += 1
    except IndexError:
        break
    try:
        pbot4 = Bot(token, 3)
        nbot += 1
    except IndexError:
        break
    try:
        pbot5 = Bot(token, 4)
        nbot += 1
    except IndexError:
        break
    try:
        pbot6 = Bot(token, 5)
        nbot += 1
    except IndexError:
        break
    try:
        pbot7 = Bot(token, 6)
        nbot += 1
    except IndexError:
        break
    try:
        pbot8 = Bot(token, 7)
        nbot += 1
    except IndexError:
        break
    try:
        pbot9 = Bot(token, 8)
        nbot += 1
    except IndexError:
        break
    try:
        pbot10 = Bot(token, 9)
        nbot += 1
    except IndexError:
        break
    try:
        pbot11 = Bot(token, 10)
        nbot += 1
    except IndexError:
        break
    try:
        pbot12 = Bot(token, 11)
        nbot += 1
    except IndexError:
        break
    try:
        pbot13 = Bot(token, 12)
        nbot += 1
    except IndexError:
        break
    try:
        pbot14 = Bot(token, 13)
        nbot += 1
    except IndexError:
        break
    try:
        pbot15 = Bot(token, 14)
        nbot += 1
    except IndexError:
        break
    try:
        pbot16 = Bot(token, 15)
        nbot += 1
    except IndexError:
        break
    try:
        pbot17 = Bot(token, 16)
        nbot += 1
    except IndexError:
        break
    try:
        pbot18 = Bot(token, 17)
        nbot += 1
    except IndexError:
        break
    try:
        pbot19 = Bot(token, 18)
        nbot += 1
    except IndexError:
        break
    try:
        pbot20 = Bot(token, 19)
        nbot += 1
    except IndexError:
        break
    try:
        pbot21 = Bot(token, 20)
        nbot += 1
    except IndexError:
        break
    try:
        pbot22 = Bot(token, 21)
        nbot += 1
    except IndexError:
        break
    try:
        pbot23 = Bot(token, 22)
        nbot += 1
    except IndexError:
        break
    try:
        pbot24 = Bot(token, 23)
        nbot += 1
    except IndexError:
        break
    try:
        pbot25 = Bot(token, 24)
        nbot += 1
    except IndexError:
        break
    try:
        pbot26 = Bot(token, 25)
        nbot += 1
    except IndexError:
        break
    try:
        pbot27 = Bot(token, 26)
        nbot += 1
    except IndexError:
        break
    try:
        pbot28 = Bot(token, 27)
        nbot += 1
    except IndexError:
        break
    try:
        pbot29 = Bot(token, 28)
        nbot += 1
    except IndexError:
        break
    try:
        pbot30 = Bot(token, 29)
        nbot += 1
    except IndexError:
        break
    try:
        pbot31 = Bot(token, 30)
        nbot += 1
    except IndexError:
        break
    try:
        pbot32 = Bot(token, 31)
        nbot += 1
    except IndexError:
        break
    try:
        pbot33 = Bot(token, 32)
        nbot += 1
    except IndexError:
        break
    try:
        pbot34 = Bot(token, 33)
        nbot += 1
    except IndexError:
        break
    try:
        pbot35 = Bot(token, 34)
        nbot += 1
    except IndexError:
        break
    try:
        pbot36 = Bot(token, 35)
        nbot += 1
    except IndexError:
        break
    try:
        pbot37 = Bot(token, 36)
        nbot += 1
    except IndexError:
        break
    try:
        pbot38 = Bot(token, 37)
        nbot += 1
    except IndexError:
        break
    try:
        pbot39 = Bot(token, 38)
        nbot += 1
    except IndexError:
        break
    try:
        pbot40 = Bot(token, 39)
        nbot += 1
    except IndexError:
        break
    try:
        pbot41 = Bot(token, 40)
        nbot += 1
    except IndexError:
        break
    try:
        pbot42 = Bot(token, 41)
        nbot += 1
    except IndexError:
        break
    try:
        pbot43 = Bot(token, 42)
        nbot += 1
    except IndexError:
        break
    try:
        pbot44 = Bot(token, 43)
        nbot += 1
    except IndexError:
        break
    try:
        pbot45 = Bot(token, 44)
        nbot += 1
    except IndexError:
        break
    try:
        pbot46 = Bot(token, 45)
        nbot += 1
    except IndexError:
        break
    try:
        pbot47 = Bot(token, 46)
        nbot += 1
    except IndexError:
        break
    try:
        pbot48 = Bot(token, 47)
        nbot += 1
    except IndexError:
        break
    try:
        pbot49 = Bot(token, 48)
        nbot += 1
    except IndexError:
        break
    try:
        pbot50 = Bot(token, 49)
        nbot += 1
    except IndexError:
        break
    else:
        print("Maximum overload")

if nbot == 1:
    async def main():
        await pbot1.start()
elif nbot == 2:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start()
            )
elif nbot == 3:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start()
            )
elif nbot == 4:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start()
            )
elif nbot == 5:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start()
            )
elif nbot == 6:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start()
            )
elif nbot == 7:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start()
            )
elif nbot == 8:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start()
            )
elif nbot == 9:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start()
            )
elif nbot == 10:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start()
            )
elif nbot == 11:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start()
            )
elif nbot == 12:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start()
            )
elif nbot == 13:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start()
            )
elif nbot == 14:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start()
            )
elif nbot == 15:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start()
            )
elif nbot == 16:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start()
            )
elif nbot == 17:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start()
            )
elif nbot == 18:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start()
            )
elif nbot == 19:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start()
            )

elif nbot == 20:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start()
            )
elif nbot == 21:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start()
            )
elif nbot == 22:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start()
            )
elif nbot == 23:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start()
            )
elif nbot == 24:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start()
            )
elif nbot == 25:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start()
            )
elif nbot == 26:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot26.start()
            )
elif nbot == 27:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start()
            )
elif nbot == 28:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start()
            )
elif nbot == 29:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start()
            )
elif nbot == 30:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start()
            )
elif nbot == 31:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start()
            )
elif nbot == 32:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start()
            )
elif nbot == 33:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start()
            )
elif nbot == 34:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start()
            )
elif nbot == 35:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start()
            )
elif nbot == 36:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start()
            )

elif nbot == 37:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start()
            )
elif nbot == 38:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start()
            )
elif nbot == 39:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start()
            )
elif nbot == 40:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start()
            )
elif nbot == 41:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start()
            )
elif nbot == 42:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start()
            )
elif nbot == 43:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start()
            )
elif nbot == 44:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start()
            )
elif nbot == 45:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start()
            )
elif nbot == 46:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start(),
            pbot46.start()
            )
elif nbot == 47:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start(),
            pbot46.start(),
            pbot47.start()
            )
elif nbot == 48:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start(),
            pbot46.start(),
            pbot47.start(),
            pbot48.start()
            )
elif nbot == 49:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start(),
            pbot46.start(),
            pbot47.start(),
            pbot48.start(),
            pbot49.start()
            )
elif nbot == 50:
    async def main():
        await asyncio.gather(
            pbot1.start(),
            pbot2.start(),
            pbot3.start(),
            pbot4.start(),
            pbot5.start(),
            pbot6.start(),
            pbot7.start(),
            pbot8.start(),
            pbot9.start(),
            pbot10.start(),
            pbot10.start(),
            pbot11.start(),
            pbot12.start(),
            pbot13.start(),
            pbot14.start(),
            pbot15.start(),
            pbot16.start(),
            pbot17.start(),
            pbot18.start(),
            pbot19.start(),
            pbot20.start(),
            pbot21.start(),
            pbot22.start(),
            pbot23.start(),
            pbot24.start(),
            pbot25.start(),
            pbot26.start(),
            pbot27.start(),
            pbot28.start(),
            pbot29.start(),
            pbot30.start(),
            pbot31.start(),
            pbot32.start(),
            pbot33.start(),
            pbot34.start(),
            pbot35.start(),
            pbot36.start(),
            pbot37.start(),
            pbot38.start(),
            pbot39.start(),
            pbot40.start(),
            pbot41.start(),
            pbot42.start(),
            pbot43.start(),
            pbot44.start(),
            pbot45.start(),
            pbot46.start(),
            pbot47.start(),
            pbot48.start(),
            pbot49.start(),
            pbot50.start()
            )

asyncio.run(main())
