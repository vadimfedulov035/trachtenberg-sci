#!/bin/sh

cbotf(){
	touch cids.log
	./cidc &
	./cbot &
}

killf(){
	killall cidc cbot
}

while true; do
	[ $(date | cut -d" " -f 5 | cut -d":" --fields 1,2) = "21:00" ] && killf && rm -f cids.log && cbotf && echo "Timebased restart of bot occured at $(date | cut -d" " -f 4)"
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart of bot occured because at $(date | cut -d" " -f 4)"
	sleep $(( 60 - $(date | cut -d" " -f 4 | cut -d":" -f 3) ))
done
