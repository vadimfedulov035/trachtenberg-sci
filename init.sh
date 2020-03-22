#!/bin/sh

pbot(){
sh -c "$(./start.py)" &
}

while [ `date | cut -d" " -f 4 | cut -d":" -f 3` != 00 ]; do
	sleep 0.1
done

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" --fields 1,2` = 21:00 ]; then
			killall python3
			pbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3` ]; then
		pbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
