#!/bin/sh

cbot(){
sh -c "$(./start.py)" &
}

killall python3.7

until [ `date | cut -d" " -f 4 | cut -d":" -f 3` = 00 ]; do
	sleep 1
done

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 1` = 16 ] && [ `date | cut -d" " -f 4 | cut -d":" -f 2` = 00 ]; then
			killall python3.7
			cbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3.7` ]; then
		killall python3.7
		cbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
