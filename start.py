import asyncio
from bot import Bot


with open("tok.conf", "r") as config:
    token = config.read().rstrip()


pbot0 = Bot(token, 0)
pbot1 = Bot(token, 1)
pbot2 = Bot(token, 2)
pbot3 = Bot(token, 3)
pbot4 = Bot(token, 4)
pbot5 = Bot(token, 5)
pbot6 = Bot(token, 6)
pbot7 = Bot(token, 7)
pbot8 = Bot(token, 8)
pbot9 = Bot(token, 9)
pbot10 = Bot(token, 10)
pbot11 = Bot(token, 11)
pbot12 = Bot(token, 12)
pbot13 = Bot(token, 13)
pbot14 = Bot(token, 14)
pbot15 = Bot(token, 15)
pbot16 = Bot(token, 16)
pbot17 = Bot(token, 17)
pbot18 = Bot(token, 18)
pbot19 = Bot(token, 19)
pbot20 = Bot(token, 20)
pbot21 = Bot(token, 21)
pbot22 = Bot(token, 22)
pbot23 = Bot(token, 23)
pbot24 = Bot(token, 24)
pbot25 = Bot(token, 25)
pbot26 = Bot(token, 26)
pbot27 = Bot(token, 27)
pbot28 = Bot(token, 28)
pbot29 = Bot(token, 29)
pbot30 = Bot(token, 30)
pbot31 = Bot(token, 31)
pbot32 = Bot(token, 32)
pbot33 = Bot(token, 33)
pbot34 = Bot(token, 34)
pbot35 = Bot(token, 35)
pbot36 = Bot(token, 36)
pbot37 = Bot(token, 37)
pbot38 = Bot(token, 38)
pbot39 = Bot(token, 39)
pbot40 = Bot(token, 40)
pbot41 = Bot(token, 41)
pbot42 = Bot(token, 42)
pbot43 = Bot(token, 43)
pbot44 = Bot(token, 44)
pbot45 = Bot(token, 45)
pbot46 = Bot(token, 46)
pbot47 = Bot(token, 47)
pbot48 = Bot(token, 48)
pbot49 = Bot(token, 49)


async def main():
    await asyncio.gather(
        pbot0.start(),
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

loop = asyncio.get_event_loop()
loop.run_until_complete(main())
