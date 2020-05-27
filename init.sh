#!/bin/sh

cbotf(){
	rm -f cids.log
	touch cids.log
	./cidc &
	./cbot &
}

killf(){
	killall cidc cbot
}


while true; do
	[ `date | cut -d" " -f 4 | cut -d":" --fields 1,2` = 00:00 ] && [ `date | cut -d" " -f 1` = "Fri" ] && killf && cbotf && echo "Restart: `date`"
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart: `date`"
	sleep 0.1
done
