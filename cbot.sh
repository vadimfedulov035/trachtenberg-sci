#!/bin/sh

echo "Start of cbot"

cbot(){
        ./cbot.exe
}

while true; do
        if [ -z `fping "api.telegram.org" | grep "alive"` ]; then
                echo "Connection was lost! Now waiting 5s and trying to restart cbot!"
                wait 5
                cbot
        else
                cbot
        fi
done
