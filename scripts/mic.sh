#!/usr/bin/env bash

mic_status=$(pactl list sources | grep -A 10 "$(pactl get-default-source)" | grep Mute | awk '{print $2}')

if [ "$mic_status" == "yes" ]; then
	echo '{"text":"", "class": "mic"}';
else
	echo '{"text":"", "class": "mic"}';
fi

