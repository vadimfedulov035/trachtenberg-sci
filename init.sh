#!/bin/sh

cbot(){
touch cids.log
./cidc.exe &
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

while [ `date | cut -d" " -f 5 | cut -d":" -f 3` != 00 ]; do
	sleep 0.01
done

rm -f cids.log

while true; do
	if [ `date | cut -d" " -f 5 | cut -d":" --fields 1,2` = 21:00 ]; then
		rm -f cids.log
		killall cbot*.exe
		cbot
		echo "Timebased restart of bot occured"
	elif [ -z `pgrep cbot0.exe` ]; then
		cbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
