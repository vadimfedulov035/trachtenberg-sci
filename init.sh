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
	[ `date | cut -d" " -f 4 | cut -d":" --fields 1,2` = 00:00 ] && [ `date | cut -d" " -f 1` = "Fri" ] && killf && rm -f cids.log && cbotf && echo "Restart of bot occured because of time at `date | cut -d" " -f 4`"
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart of bot occured because of not found processes at `date | cut -d" " -f 4`"
	stime=`date | cut -d" " -f 4 | cut -d":" -f 3`  # two decimal seconds
	[ `echo $stime | cut -c 1` = 0 ] && stime=`echo $stime | cut -c 2`  # seconds with leading zero
	sleep $((60 - $stime))
done
