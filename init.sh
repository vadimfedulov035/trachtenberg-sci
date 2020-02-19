#!/bin/sh

cbot(){
sh -c "$(./start.py)" &
}

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 2` = "00" ]; then
			killall python3.7
			echo "Timebased restart of bot occured"
			cbot
	elif [ -z `pgrep python3.7` ]; then
		echo "Start of bot occured, whether it was reconnection or first start"
		cbot
	fi
	sleep 35
done
