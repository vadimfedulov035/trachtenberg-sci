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
pbot15 = Bot(token, 14)
pbot16 = Bot(token, 14)
pbot17 = Bot(token, 14)
pbot18 = Bot(token, 14)
pbot19 = Bot(token, 14)
pbot20 = Bot(token, 20)
pbot21 = Bot(token, 21)
pbot22 = Bot(token, 22)
pbot23 = Bot(token, 23)
pbot24 = Bot(token, 24)


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

loop = asyncio.get_event_loop()
loop.run_until_complete(main())
