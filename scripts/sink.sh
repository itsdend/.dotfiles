#!/usr/bin/env bash

mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')

get_sink_volume() {
  local sink="$1"
  pactl list sinks | awk -v s="$sink" '
    $0 ~ "Name: "s {found=1}
    found && /Volume:/ {
      print $0
      found=0
    }' | sed -E 's/.* ([0-9]+)%.*$/\1%/'
}


get_sink_nick() {
  local sink="$1"
  pactl list sinks | awk -v s="$sink" '
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
    *"VG32"*)
      echo "🎵"
      ;;
    *"H848"*|*"Wireless"*|*"Redragon"*)
      echo "🔊"
      ;;
    *"ALC"*)
      echo "laptop"
      ;;
    *)
      echo "🔈"
      ;;
  esac
}


get_priority_for_nick() {
  local nick="$1"

  case "$nick" in
    *"VG32"*)
      echo 1
      ;;
    *"H848"*|*"Wireless"*|*"Redragon"*)
      echo 2
      ;;
    *"ALC"*)
      echo 3
      ;;
    *)
      echo 9
      ;;
  esac
}



options=()

for sink in "${sinks[@]}"; do
  nick=$(get_sink_nick "$sink")
  vol=$(get_sink_volume "$sink")

  label="${nick:-$sink}"
  icon=$(get_icon_for_nick "$label")
  priority=$(get_priority_for_nick "$label")

  # prepend priority for sorting
  options+=("$priority|$icon  $label ($vol)|$sink")
done

# sort by priority (numeric)
sorted=$(printf "%s\n" "${options[@]}" | sort -t'|' -k1,1n)

chosen_label=$(printf "%s\n" "$sorted" \
  | cut -d '|' -f2 \
  | rofi -dmenu -i -matching fuzzy -p "Audio Output")

sink_to_set=$(printf "%s\n" "$sorted" \
  | grep "|$chosen_label|" \
  | cut -d '|' -f3)

if [[ -n "$sink_to_set" ]]; then
  pactl set-default-sink "$sink_to_set"

  for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$sink_to_set"
  done
fi
