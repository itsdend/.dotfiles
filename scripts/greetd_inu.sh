#!/usr/bin/env bash

while true; do
  clear

  # ANSI purple (compatible with TTY 8-color)
  PURPLE="\033[0;35m"
  RED="\033[0;31m"
  CYAN="\033[0;36m"
  YELLOW="\033[0;33m"
  RESET="\033[0m"

  rows=$(tput lines)
  cols=$(tput cols)

  box_height=11
  min_width=40
  max_width=60
  calculated_width=$(( cols / 3 ))

  if ((calculated_width < min_width)); then
    box_width=$min_width
  elif ((calculated_width > max_width)); then
    box_width=$max_width
  else
    box_width=$calculated_width
  fi

  row_start=$(( (rows - box_height) / 4 ))
  col_start=$(( (cols - box_width) / 2 ))


echo "Running as user: $(whoami)"
  # Draw box
  tput cup $row_start $col_start
  echo -ne "${PURPLE}┌$(printf '─%.0s' $(seq 1 $((box_width - 2))))┐"

  for i in $(seq 1 $((box_height - 2))); do
    tput cup $((row_start + i)) $col_start
    echo -ne "│"
    tput cup $((row_start + i)) $((col_start + box_width -1))
    echo -ne "│"
  done

  tput cup $((row_start + box_height -1)) $col_start
  echo -ne "└$(printf '─%.0s' $(seq 1 $((box_width - 2))))┘${RESET}"

  # Title
  title="Logging into NixOS/Hyprland"
  title_pos=$(( col_start + (box_width - ${#title}) / 2 ))
  tput cup $row_start $title_pos
  echo -ne "${PURPLE}${title}${RESET}"

  content_start_row=$((row_start + 1))
  content_width=$((box_width - 2))
  content_col_start=$((col_start + 1))
  footer_row=$((row_start + box_height - 2))

  # Footer prompt
  footer_msg="F1 Shutdown    F2 Reboot    ENTER Login"
  footer_pos=$(( content_col_start + (content_width - ${#footer_msg}) / 2 ))
  tput cup $footer_row $footer_pos
  echo -ne "${YELLOW}$footer_msg${RESET}"

  
# Your ASCII art as an array (each line one element)
ascii_art=(
"     #@@-                                       "
"    @@@G@@@:              ▗▄▄▄▄    ▄▄▄▖         "
"   .@@GGGGG@@@..           ▜███▙  ▟███▛         "
"   .@@G#####GG@@@@:         ▜███▙▟███▛          "
"   .@@G%####GGGG@@@@@@@@@@   ▜██████▛           "
"   .@@GG####GGGGGG@@GGGGG@██▙ ▜████▛     ▟▙     "
"   .%@GGG###GG@@@GGGGGGGGG███▙ ▜███▙    ▟██▙    "
"    @@@GGGGGGG@@@@@@@GGGGG      ▜███▙  ▟███▛    "
"    %@@G@@@@@@@@@@@@@@@@@G       ▜██▛ ▟███▛     "
"    -@@@@@@@@@@@=* ...@@GG        ▜▛ ▟███▛      "
"   :*%@@@@@@@@@- |X   @GGG          ▟██████████▙"
"    #@@@@@@@@@@-     @GGGG         ▟███████████▛"
"   *@@@@@@@@#######GGGGGGG        ▟███▛         "
" -:+@@@@@########&G#/            ▟███▛          "
"  %@@@@@########G#/  XXXX       ▝▀▀▀▀           "
".#@@@@@########G####\\ ''  ████████████████▛    "
"=#%@@%#########G######\\   ███████████████▛     "
"  .@@# .:%################     ▜███▙            "
"    .GG     :###########/       ▜███▙           "
"    -%GGG    .#######/           ▜███▙          "
"      +@GG:          _<###▘       ▀▀▀▘          "
"      .%@@@@%.          ~#                      "
"        +@@@@@#*%#:                             "
"        :%@@@@@@@@#####%++                      "
"         .=#@@@@@@@#######                      "
"             =@@@@@@@@####                      "
"                   ..::###                      "
)

# Calculate starting row (one after the box bottom)
art_start_row=$(( row_start + box_height + 5))

# Print each line centered horizontally
for line in "${ascii_art[@]}"; do
  art_col_start=$(( col_start + (box_width - ${#line}) / 2 ))
  tput cup $art_start_row $art_col_start
  echo -ne "${CYAN}$line${RESET}"
  ((art_start_row++))
done


  # Wait for user action
  while true; do
    read -rsn 1 key
    if [[ $key == $'\e' ]]; then
      # Read up to 3 characters more to get full sequence (ESC + 3 = 4 chars)
      read -rsn 3 rest
      full_key="$key$rest"
      case "$full_key" in
        $'\e[[A') poweroff;;
        $'\e[[B') reboot;;
        *)
          ;;
      esac
    elif [[ $key == "" ]]; then
      break
    fi
  done

  # Prompt for username
  user_prompt_row=$content_start_row
  user_label="Username: "
  user_label_pos=$(( content_col_start + (content_width - ${#user_label} - 15) / 2 ))
  tput cup $user_prompt_row $user_label_pos
  echo -n "$user_label"
  read -r USERNAME

  if [[ -z "$USERNAME" ]]; then
    fail_msg="No user entered"
    fail_pos=$(( content_col_start + (content_width - ${#fail_msg}) / 2 ))
    tput cup $((user_prompt_row + 1)) $fail_pos
    echo -ne "${RED}$fail_msg${RESET}"
    sleep 1
    continue
  fi

  # Prompt for password
  password_prompt_row=$((user_prompt_row + 2))
  pass_prompt="Password: "
  pass_prompt_pos=$(( content_col_start + (content_width - ${#pass_prompt} - 15) / 2 ))
  tput cup $password_prompt_row $pass_prompt_pos
  read -rs -p "$pass_prompt" PASSWORD
  echo

  # Authenticate
  if ! echo "$PASSWORD" |sudo pamtester login "$USERNAME" authenticate > /dev/null 2>&1; then
    fail_msg="Authentication failed"
    fail_pos=$(( content_col_start + (content_width - ${#fail_msg}) / 2 ))
    tput cup $((password_prompt_row + 1)) $fail_pos
    echo -ne "${RED}$fail_msg${RESET}"
    sleep 1
    continue
  fi

  clear
  echo  "prosao prvi dio"
  # export XDG_RUNTIME_DIR="/run/user/$(id -u "$USERNAME")"
  # exec sudo -u "$USERNAME" env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" Hyprland

  # exec sudo -u "$USERNAME" login -fp "$USERNAME"
  # sudo -u "$USERNAME" login -fp "$USERNAME" -- bash -l -c 'exec Hyprland'
  # exec sudo -u "$USERNAME" login -fp "$USERNAME" -- bash -l -c 'exec Hyprland'
  
  # exec sudo login -p -f "$USERNAME"
  machinectl shell "$USERNAME@" /etc/profiles/per-user/$USERNAME/bin/Hyprland
  # -- bash -l -c 'exec Hyprland'
done
