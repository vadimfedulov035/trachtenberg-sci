#!/bin/sh

pbot(){
sh -c "$(./start.py)"  &
}

killall python3.7

until [ `date | cut -d" " -f 5 | cut -d":" -f 3` = 00 ]; do
	sleep 1
done

while true; do
	if [ `date | cut -d" " -f 5 | cut -d":" -f 1` = 13 ] && [ `date | cut -d" " -f 5 | cut -d":" -f 2` = 00 ]; then
			killall python3.7
			pbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3.7` ]; then
		killall python3.7
		pbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
