#!/usr/bin/env bash

if makoctl mode | grep -q "do-not-disturb"; then
    echo '{"text":"󰂛 ", "class":"dnd"}'
else
    echo '{"text":"󰂚 ", "class":"dnd"}'
fi
