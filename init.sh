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
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart of bot occured because of unknown error at `date | cut -d" " -f 4`"
	stime=`date | cut -d" " -f 4 | cut -d":" -f 3`  # two decimal seconds
	[ `echo $stime | cut -c 1` = 0 ] && stime=`echo $stime | cut -c 2`  # seconds with leading zero
	sleep $((60 - $stime))
done
