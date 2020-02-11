#!/bin/sh

echo "Start of cbot"

xfce4-terminal -e /home/devbr/Documents/Projects/trachtenberg-sci/__cbot__/cbot.exe

while true; do
	if [ `fping "api.telegram.org" | grep "alive" | cut -d" " -f 3` != "alive" ]; then
		printf "\nConnection was lost! Now waiting 10s and trying to restart cbot!"
	elif [ `date | cut -d" " -f 5 | cut -d":" -f 2` == "00" ]; then
		killall cbot.exe; xfce4-terminal -e /home/devbr/Documents/Projects/trachtenberg-sci/__cbot__/cbot.exe
	fi
	wait 10
done
