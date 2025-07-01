#!/usr/bin/env bash

# Display one-line notifications in rofi
selection=$(makoctl history | jq -r '.data[0][] | "\(."app-name".data): \(.summary.data): \(.body.data)"' | rofi -dmenu -p "Notification history"
)

# Exit if nothing selected
[ -z "$selection" ] && exit

# Extract parts
app=$(echo "$selection" | cut -d':' -f1 | xargs)
summary=$(echo "$selection" | cut -d':' -f2 | xargs)
body=$(echo "$selection" | cut -d':' -f3- | xargs)

echo "$summary" | wl-copy

# Show full message (optional)
message=$(printf "App: %s\nSummary: %s\n\n%s\n" "$app" "$summary" "$body")
rofi -e "$message"
