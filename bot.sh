#!/bin/sh

cbot(){
./start.py
}

echo "Start of cbot"

while true; do
	if [ `date | cut -d" " -f 5 | cut -d":" -f 2` = 00 ]; then
			killall python3; cbot
	elif [ -z `pgrep python3` ]; then
		echo "Start of bout occured, whether it was connection error or first time of start!"
		cbot
	fi
	sleep 10
done
