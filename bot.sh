#!/bin/sh

cbot(){
./start.py
}

echo "Start of cbot"

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 2` = 00 ]; then
			killall python3; cbot && echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3` ]; then
		cbot && echo "Start of bot occured, whether it was connection error or first time of start!"
	fi
	sleep 10
done
