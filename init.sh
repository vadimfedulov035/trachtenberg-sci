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
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart of bot occured at `date | cut -d" " -f 4`"
	sleep 0.1 
done
