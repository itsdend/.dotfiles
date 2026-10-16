#!/usr/bin/env bash

history=$(makoctl history -j)

# rofi returns the selected row index (-format i), so no label parsing needed
index=$(printf "%s" "$history" \
  | jq -r '.[] | "\(.app_name // "unknown"): \(.summary) \((.body // "") | gsub("\n"; " "))"' \
  | rofi -dmenu -i -matching fuzzy -format i -p "Notification history"
)

[[ -z "$index" || "$index" == -1 ]] && exit

app=$(printf "%s" "$history" | jq -r ".[$index].app_name // \"unknown\"")
summary=$(printf "%s" "$history" | jq -r ".[$index].summary")
body=$(printf "%s" "$history" | jq -r ".[$index].body // \"\"")

text="$summary"
[ -n "$body" ] && text+=$'\n'"$body"

printf "%s" "$text" | wl-copy

rofi -e "App: $app"$'\n\n'"$text"
