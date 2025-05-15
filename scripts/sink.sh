#!/usr/bin/env bash

# Get list of sinks
mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')

# Function to get volume for a sink
get_sink_volume() {
  local sink="$1"
  pactl list sinks | awk -v s="$sink" '
    $0 ~ "Name: "s {found=1}
    found && /Volume:/ {
      print $0
      found=0
    }' | sed -E 's/.* ([0-9]+)%.*$/\1%/'
}
# Optional: define pretty display names or emojis (customize as needed)
declare -A sink_icons
sink_icons["alsa_output.pci-0000_c3_00.1.HiFi__HDMI4__sink"]="🎵  monitor main"
sink_icons["alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.analog-stereo"]="🔊  wireless redragon"

# Build menu: "Label (Volume)" | actual sink
options=()
for sink in "${sinks[@]}"; do
  label="${sink_icons[$sink]:-$sink}"
  vol=$(get_sink_volume "$sink")
  display="${label} (${vol})"
  options+=("$display|$sink")
done

# Show menu
chosen_label=$(printf "%s\n" "${options[@]}" | cut -d '|' -f1 | rofi -dmenu -i matching fuzzy -p "Audio Output")

# Extract actual sink name
sink_to_set=$(printf "%s\n" "${options[@]}" | grep "^$chosen_label|" | cut -d '|' -f2-)

# Set default sink and move streams
if [[ -n "$sink_to_set" ]]; then
  pactl set-default-sink "$sink_to_set"

  # Move all active audio streams to the new sink
  for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$sink_to_set"
  done
fi
