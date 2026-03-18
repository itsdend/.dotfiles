#!/usr/bin/env bash

selection=$(makoctl history \
  | awk '
      /^Notification/ {
          id=$2
          sub(":", "", id)
          summary=$0
          getline
          app=$0
          sub(/^  App name: /, "", app)
          print id "|" app "|" summary
      }
  ' \
  | rofi -dmenu -p "Notification history"
)

[ -z "$selection" ] && exit

id=$(echo "$selection" | cut -d'|' -f1)
app=$(echo "$selection" | cut -d'|' -f2)
summary=$(echo "$selection" | cut -d'|' -f3-)

echo "$summary" | wl-copy

rofi -e "App: $app\n\n$summary"
