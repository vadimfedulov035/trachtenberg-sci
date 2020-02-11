#!/bin/sh

echo "Start of cbot"
tgerr = false

xfce4-terminal -e /home/devbr/Documents/Projects/trachtenberg-sci/__cbot__/cbot.exe

while true; do
        if [ -z `fping "api.telegram.org" | grep "alive"` ]; then
                printf "\nConnection was lost! Now waiting 5s and trying to restart cbot!"
                sleep 10
		tgerr = true
	if [ "$tgerr" == false ]; then
		if [ `date | cut -d" " -f 5 | cut -d":" -f 2` == "00" ]; then
			killall cbot.exe && xfce4-terminal -e "./cbot.exe"
		fi
	elif [ "$tgerr" == true ]; then
		killall cbot.exe && xfce4-terminal -e "./cbot.exe"
		tgerr = false
        fi
done
}

wloop
