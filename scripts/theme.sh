#!/usr/bin/env bash

# Paths
DOTFILES_THEMES="$HOME/.dotfiles/themes"
THEMES_DIR="$HOME/.config/inu_nix/themes"
CURRENT_THEME_SYMLINK="$THEMES_DIR/current"

# Ensure theme directory exists
mkdir -p "$THEMES_DIR"
mkdir -p "$HOME/.config/wezterm/themes/current"

# Create default symlink if it doesn't exist
if [ ! -L "$CURRENT_THEME_SYMLINK" ]; then
    echo "Creating default theme symlink..."
    ln -nsf "$DOTFILES_THEMES/pastel_inu_cyber" "$CURRENT_THEME_SYMLINK"
fi

# List all theme folders in ~/.dotfiles/themes
mapfile -t themes < <(find "$DOTFILES_THEMES" -maxdepth 1 -mindepth 1 -type d -printf "%f\n")

# Let user select a theme via rofi
chosen_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -i -p "Select Theme")

# Exit if nothing selected
[[ -z "$chosen_theme" ]] && exit 0

# Make sure the theme has everything the rest of the setup loads from themes/current
missing=()
for file in hyprland.conf hyprlock.conf larserikfinhold.omp.json mako.ini rofi_config.rasi waybar.css; do
    [[ -f "$DOTFILES_THEMES/$chosen_theme/$file" ]] || missing+=("$file")
done
if (( ${#missing[@]} )); then
    notify-send -u critical "Theme $chosen_theme is missing files" "${missing[*]}"
    exit 1
fi

# Update the symlink to the chosen theme
ln -nsf "$DOTFILES_THEMES/$chosen_theme" "$CURRENT_THEME_SYMLINK"

notify-send "Switched to theme: $chosen_theme"
# Reload Hyprland and Mako
pkill waybar
# wait for the old instance to exit so we don't end up with two bars
for _ in {1..30}; do pgrep -x waybar >/dev/null || break; sleep 0.1; done
hyprctl dispatch exec waybar
hyprctl reload
makoctl reload
# oh-my-posh enable reload

# hyprctl reload re-applies monitor= lines and turns eDP-1 back on,
# so re-apply the lid state (same logic as the Lid Switch bindl in hyprland.conf)
lid_state=$(awk '{print $2}' /proc/acpi/button/lid/LID*/state 2>/dev/null | head -n1)
if [[ "$lid_state" == "closed" ]]; then
	hyprctl keyword monitor "eDP-1, disable"
else
	hyprctl keyword monitor "eDP-1, highres, auto, 1"
fi
