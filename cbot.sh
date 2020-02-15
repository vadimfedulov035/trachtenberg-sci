#!/bin/sh

cbot(){
xfce4-terminal -e "torify ./cbot.exe"
}

echo "Start of cbot"
tgerr=true  # set as telegram error occured to activate bot immideately

while true; do
	if [ `ping api.telegram.org -q -c 1 | sed -n '4p' | cut -d' ' -f 4` = 1 ]; then
		if [ `date | cut -d" " -f 5 | cut -d":" -f 2` = 00 ] || [ $tgerr = true ]; then
			tgerr=false
			killall cbot.exe
			cbot
		fi
	else
		printf "\nConnection with api.telegram.org is lost! Trying to reconnect after 50 seconds."
		tgerr=true
	fi
	sleep 50
done
