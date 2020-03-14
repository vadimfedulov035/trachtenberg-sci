#!/bin/sh

pbot(){
sh -c "$(/opt/pypy3/bin/pypy3 start.py)" &
}

while [ `date | cut -d" " -f 4 | cut -d":" -f 3` != 00 ]; do
	sleep 1
done

while true; do
	if [ `date | cut -d" " -f 4 | cut -d":" -f 1` = 14 ] && [ `date | cut -d" " -f 4 | cut -d":" -f 2` = 00 ]; then
			killall pypy3
			pbot
			echo "Timebased restart of bot occured"
	elif [ -z `pgrep pypy3` ]; then
		pbot
		echo "Start of bot occured, whether it was reconnection or first start"
	fi
	sleep 60
done
