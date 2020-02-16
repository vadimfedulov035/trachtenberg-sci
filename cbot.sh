#!/bin/sh

cbot(){
xfce4-terminal -e "torify ./cbot.exe"
}

echo "Start of cbot"
tgerr=true  # set as telegram error occured to activate bot immideately
pdate=0000

while true; do
	if [ `ping api.telegram.org -q -c 1 | sed -n '4p' | cut -d' ' -f 4` = 1 ]; then
		bdate=`date | cut -d" " -f 5`
		if [ `echo $bdate | cut -d":" -f 2` = 00 ] || [ $tgerr = true ]; then
			if [ $pdate != `echo $bdate | cut -d":" -f 1` ]; then
				tgerr=false
				pdate=`echo $bdate | cut -d":" -f 1`
				killall cbot.exe
				cbot
			fi
		fi
	else
		printf "\nConnection with api.telegram.org is lost! Trying to reconnect after 10 seconds."
		tgerr=true
	fi
	sleep 10
done
