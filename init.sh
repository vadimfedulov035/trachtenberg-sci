#!/bin/sh

cidc(){
	./cidc.exe &
}

cbot(){
	./cbot0.exe &
	./cbot1.exe &
	./cbot2.exe &
	./cbot3.exe &
	./cbot4.exe &
	./cbot5.exe &
	./cbot6.exe &
	./cbot7.exe &
	./cbot8.exe &
	./cbot9.exe &
}

while [ `date | cut -d" " -f 4 | cut -d":" -f 3` != 59 ]; do
	sleep 0.1
done

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" --fields 1,2` = 21:00 ]; then
		killall cidc.exe
		killall cbot.exe
        rm cids.log
		cidc
		sleep 1
		cbot
		echo "Timebased restart of bot occured"
	elif [ -z `pgrep cbot.exe` ]; then
		cbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
