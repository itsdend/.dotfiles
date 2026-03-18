#!/usr/bin/env bash

# Get all real sources (exclude monitor devices)
mapfile -t sources < <(pactl list short sources | awk '$2 !~ /\.monitor$/ {print $2}')

get_source_volume() {
  local source="$1"
  pactl list sources | awk -v s="$source" '
    $0 ~ "Name: "s {found=1}
    found && /Volume:/ {
      print $0
      found=0
    }' | sed -E 's/.* ([0-9]+)%.*$/\1%/'
}

get_source_nick() {
  local source="$1"
  pactl list sources | awk -v s="$source" '
    $0 ~ "Name: "s {found=1}
    found && /node.nick =/ {
      gsub(/.*= "/, "")
      gsub(/"/, "")
      print
      found=0
    }'
}

get_icon_for_nick() {
  local nick="$1"

  case "$nick" in
    *"H848"*|*"Wireless"*|*"Redragon"*)
      echo "🎧"
      ;;
    *"Webcam"*|*"C920"*)
      echo "📷"
      ;;
    *"ALC"*|*"Built-in"*|*"Analog"*)
      echo "💻"
      ;;
    *)
      echo "🎤"
      ;;
  esac
}

get_priority_for_nick() {
  local nick="$1"

  case "$nick" in
    *"H848"*|*"Wireless"*|*"Redragon"*)
      echo 1
      ;;
    *"Webcam"*|*"C920"*)
      echo 2
      ;;
    *"ALC"*|*"Built-in"*|*"Analog"*)
      echo 3
      ;;
    *)
      echo 9
      ;;
  esac
}

options=()

for source in "${sources[@]}"; do
  nick=$(get_source_nick "$source")
  vol=$(get_source_volume "$source")

  label="${nick:-$source}"
  icon=$(get_icon_for_nick "$label")
  priority=$(get_priority_for_nick "$label")

  options+=("$priority|$icon  $label ($vol)|$source")
done

# sort by priority
sorted=$(printf "%s\n" "${options[@]}" | sort -t'|' -k1,1n)

chosen_label=$(printf "%s\n" "$sorted" \
  | cut -d '|' -f2 \
  | rofi -dmenu -i -matching fuzzy -p "Audio Input")

source_to_set=$(printf "%s\n" "$sorted" \
  | grep "|$chosen_label|" \
  | cut -d '|' -f3)

if [[ -n "$source_to_set" ]]; then
  pactl set-default-source "$source_to_set"

  for stream in $(pactl list short source-outputs | awk '{print $1}'); do
    pactl move-source-output "$stream" "$source_to_set"
  done
fi
