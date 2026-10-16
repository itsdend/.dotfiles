#!/usr/bin/env bash

# One pass over `pactl list sinks` → "name<TAB>nick<TAB>volume<TAB>mute" per usable sink.
# Sinks whose port is "not available" (e.g. HDMI outputs without a monitor) are skipped.
list_sinks() {
  pactl list sinks | awk '
    function flush() {
      if (name != "" && !unavailable) print name "\t" nick "\t" vol "\t" mute
      name = ""; nick = ""; vol = ""; mute = ""; unavailable = 0
    }
    /^Sink #/ { flush() }
    /^[[:space:]]*Name:/ { name = $2 }
    /^[[:space:]]*Mute:/ { mute = $2 }
    /^[[:space:]]*Volume:/ && vol == "" { match($0, /[0-9]+%/); vol = substr($0, RSTART, RLENGTH) }
    /node.nick =/ { nick = $0; sub(/.*= "/, "", nick); sub(/"$/, "", nick) }
    /\[Out\].*not available/ { unavailable = 1 }
    END { flush() }'
}

get_icon_for_nick() {
  local nick="$1"

  case "$nick" in
    *"VG32"*|*"C27F398"*)
      echo "🖥️"
      ;;
    *"H848"*|*"Wireless"*|*"Redragon"*)
      echo "🎧"
      ;;
    *"ALC"*)
      echo "💻"
      ;;
    *)
      echo "🔈"
      ;;
  esac
}


get_priority_for_nick() {
  local nick="$1"

  case "$nick" in
    *"VG32"*|*"C27F398"*)
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

while IFS=$'\t' read -r sink nick vol mute; do
  label="${nick:-$sink}"
  icon=$(get_icon_for_nick "$label")
  priority=$(get_priority_for_nick "$label")
  [[ "$mute" == "yes" ]] && vol="$vol, muted"

  # prepend priority for sorting
  options+=("$priority"$'\t'"$sink"$'\t'"$icon  $label ($vol)")
done < <(list_sinks)

# sort by priority (numeric)
mapfile -t sorted < <(printf "%s\n" "${options[@]}" | sort -t$'\t' -k1,1n)

# rofi returns the selected row index (-format i), so labels never need parsing
index=$(printf "%s\n" "${sorted[@]}" \
  | cut -f3 \
  | rofi -dmenu -i -matching fuzzy -format i -p "Audio Output")

[[ -z "$index" || "$index" == -1 ]] && exit 0

sink_to_set=$(printf "%s" "${sorted[$index]}" | cut -f2)

if [[ -n "$sink_to_set" ]]; then
  pactl set-default-sink "$sink_to_set"
  pactl set-sink-mute "$sink_to_set" 0

  for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$sink_to_set"
  done
fi
