#!/usr/bin/env bash

# Get the current mute state of the microphone
mic_status=$(pactl list sources | grep -A 10 "$(pactl get-default-source)" | grep Mute | awk '{print $2}')

# Set the correct icon based on mute status
if [ "$mic_status" == "yes" ]; then
    # text=""  # Muted icon
	echo '{"text":"", "class": "mic"}';
else
    # text=""  # Unmuted icon
	echo '{"text":"", "class": "mic"}';
fi

# Show the icon
# echo "$mic_status"

# Handle left-click for mute/unmute
# if [ "$1" == "left-click" ]; then
#     pactl set-source-mute @DEFAULT_SOURCE@ toggle
# fi

# echo "$icon"
# pri {"text": "$text"}
# echo '{"text": "%s"}' "$text"
# # Handle right-click for opening pavucontrol (input devices tab)
# if [ "$1" == "right-click" ]; then
#     pavucontrol --tab=3 &
# fi
