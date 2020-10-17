#!/bin/sh

cbotf(){
	rm -f cids.log
	touch cids.log
	./cidc &
	./cbot &
}

while true; do
	[ -z `pgrep cidc` ] || [ -z `pgrep cbot` ] && cbotf && echo "Restart: `date`"
	sleep 0.1
done
