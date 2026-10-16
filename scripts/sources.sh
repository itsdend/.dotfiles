#!/usr/bin/env bash

# One pass over `pactl list sources` → "name<TAB>nick<TAB>volume<TAB>mute" per usable source.
# Monitor sources and sources whose port is "not available" (e.g. unplugged mic jack) are skipped.
list_sources() {
  pactl list sources | awk '
    function flush() {
      if (name != "" && name !~ /\.monitor$/ && !unavailable) print name "\t" nick "\t" vol "\t" mute
      name = ""; nick = ""; vol = ""; mute = ""; unavailable = 0
    }
    /^Source #/ { flush() }
    /^[[:space:]]*Name:/ { name = $2 }
    /^[[:space:]]*Mute:/ { mute = $2 }
    /^[[:space:]]*Volume:/ && vol == "" { match($0, /[0-9]+%/); vol = substr($0, RSTART, RLENGTH) }
    /node.nick =/ { nick = $0; sub(/.*= "/, "", nick); sub(/"$/, "", nick) }
    /\[In\].*not available/ { unavailable = 1 }
    END { flush() }'
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
    *"ALC"*|*"Built-in"*|*"Digital Microphone"*)
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
    *"ALC"*|*"Built-in"*|*"Digital Microphone"*)
      echo 3
      ;;
    *)
      echo 9
      ;;
  esac
}

options=()

while IFS=$'\t' read -r source nick vol mute; do
  label="${nick:-$source}"
  icon=$(get_icon_for_nick "$label")
  priority=$(get_priority_for_nick "$label")
  [[ "$mute" == "yes" ]] && vol="$vol, muted"

  options+=("$priority"$'\t'"$source"$'\t'"$icon  $label ($vol)")
done < <(list_sources)

# sort by priority
mapfile -t sorted < <(printf "%s\n" "${options[@]}" | sort -t$'\t' -k1,1n)

# rofi returns the selected row index (-format i), so labels never need parsing
index=$(printf "%s\n" "${sorted[@]}" \
  | cut -f3 \
  | rofi -dmenu -i -matching fuzzy -format i -p "Audio Input")

[[ -z "$index" || "$index" == -1 ]] && exit 0

source_to_set=$(printf "%s" "${sorted[$index]}" | cut -f2)

if [[ -n "$source_to_set" ]]; then
  pactl set-default-source "$source_to_set"
  pactl set-source-mute "$source_to_set" 0

  for stream in $(pactl list short source-outputs | awk '{print $1}'); do
    pactl move-source-output "$stream" "$source_to_set"
  done

  # refresh waybar mic module
  pkill -RTMIN+8 waybar
fi
