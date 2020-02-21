#!/bin/sh

cbot(){
sh -c "$(./start.py)" &
}

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 1` = 23 ]; then
			killall python3.7
			cbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3.7` ]; then
		killall python3.7
		cbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 30
done
