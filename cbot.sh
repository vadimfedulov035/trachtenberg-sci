#!/bin/sh

echo "Start of cbot"

./cbot.exe

wloop(){
while true; do
        if [ -z `fping "api.telegram.org" | grep "alive"` ]; then
                printf "\nConnection was lost! Now waiting 5s and trying to restart cbot!"
                wait 5
        else
		killall cbot.exe
                ./cbot.exe & cloop
        fi
done
}

cloop(){
while true; do
	if [ `date | cut -d" " -f 5 | cut -d":" -f 2` = 00 ]; then
		wloop
	else
		wait 5
	fi
done
}
