#!/bin/sh

echo "Start of cbot"
tgerr=false

xfce4-terminal -e "./cbot.exe"

while true; do
        if [ $((`ping api.telegram.org -q -c 10 | sed -n '4p' | cut -d' ' -f 4` -ge 5)) ]; then
		printf "\nConnection was lost! Now waiting 10 seconds and trying to restart cbot!"
		sleep 10
		tgerr=true
	else:
		if [ "$tgerr" = false ]; then
			if [ `date | cut -d" " -f 5 | cut -d":" -f 2` == "00" ]; then
				killall cbot.exe && xfce4-terminal -e "./cbot.exe"
			fi
		elif [ "$tgerr" = true ]; then
			killall cbot.exe && xfce4-terminal -e "./cbot.exe" && tgerr=false
		fi
	fi
done
}

wloop
