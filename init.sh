#!/bin/sh

cbot(){
touch ucids.p
./cbot.exe &
}

while [ `date | cut -d" " -f 5 | cut -d":" -f 3` != 00 ]; do
	sleep 0.01
done

while true; do
	if [ `date | cut -d" " -f 5 | cut -d":" --fields 1,2` = 21:00 ]; then
		killall cbot.exe
		rm -rf ucids.p
		cbot
		echo "Timebased restart of bot occured"
	elif [ -z `pgrep cbot.exe` ]; then
		cbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
