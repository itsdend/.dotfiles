#!/usr/bin/env bash

mic_status=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$mic_status" == "yes" ]; then
	echo '{"text":"", "class": "muted"}';
else
	echo '{"text":"", "class": "unmuted"}';
fi

