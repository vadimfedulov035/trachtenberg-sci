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
        )

loop = asyncio.get_event_loop()
loop.run_until_complete(main())
