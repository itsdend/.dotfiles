#!/usr/bin/env bash

# read the real state from mako instead of a cache file, so it survives mako restarts
STATE=$(makoctl mode | grep -qx "do-not-disturb" && echo off || echo on)

if [[ "$STATE" == "on" ]]; then
	if command -v notify-send &>/dev/null; then
		notify-send "󰂛	Notifications are off	󰂛"  -t 800
	fi
		makoctl mode -a do-not-disturb

else
    makoctl mode -r do-not-disturb 
	if command -v notify-send &>/dev/null; then
		notify-send "󰂚	Notifications are on	󰂚" -t 800
	fi
fi
