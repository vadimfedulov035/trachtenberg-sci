#!/bin/sh

pbot(){
sh -c "$(python3.8 start.py)" &
}

while [ `date | cut -d" " -f 4 | cut -d":" -f 3` != 00 ]; do
	sleep 1
done

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 1` = 18 ] && [ `date | cut -d" " -f 4 | cut -d":" -f 2` = 00 ]; then
			killall python3.8
			pbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep python3.8` ]; then
		pbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
