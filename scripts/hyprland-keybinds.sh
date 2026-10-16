#!/usr/bin/env bash

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# First pass collects $variables, second pass expands them in bind/binde/bindl/bindm lines
awk '
  FNR == NR {
    if (match($0, /^\$[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=/)) {
      name = $0; sub(/[[:space:]]*=.*/, "", name)
      value = $0; sub(/^[^=]*=[[:space:]]*/, "", value); sub(/[[:space:]]*#.*/, "", value)
      vars[name] = value
    }
    next
  }
  /^bind[a-z]*[[:space:]]*=/ {
    line = $0; sub(/^[^=]*=[[:space:]]*/, "", line)
    out = ""
    while (match(line, /\$[A-Za-z_][A-Za-z0-9_]*/)) {
      token = substr(line, RSTART, RLENGTH)
      out = out substr(line, 1, RSTART - 1) ((token in vars) ? vars[token] : token)
      line = substr(line, RSTART + RLENGTH)
    }
    line = out line

    n = split(line, parts, /,[[:space:]]*/)
    mods = parts[1]; key = parts[2]
    action = parts[3]
    for (i = 4; i <= n; i++) action = action ", " parts[i]

    combo = (mods == "") ? key : mods "+" key
    print combo " → " action
  }
' "$HYPR_CONFIG" "$HYPR_CONFIG" | \
rofi -dmenu -i -matching fuzzy -p "Hyprland Keybinds"
