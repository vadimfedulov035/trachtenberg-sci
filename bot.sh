#!/bin/sh

cbot(){
exec "./start.py"
}

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 2` = "00" ]; then
			echo "Timebased restart of bot occured"
			killall python3
			cbot
	elif [ -z `pgrep python3` ]; then
		echo "Start of bot occured, whether it was connection error or first time of start!"
		cbot
	fi
	sleep 35
done
