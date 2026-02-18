#!/usr/bin/env bash

# Paths
DOTFILES_THEMES="$HOME/.dotfiles/themes"
THEMES_DIR="$HOME/.config/inu_nix/themes"
CURRENT_THEME_SYMLINK="$THEMES_DIR/current"

# Ensure theme directory exists
mkdir -p "$THEMES_DIR"

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

# Update the symlink to the chosen theme
ln -nsf "$DOTFILES_THEMES/$chosen_theme" "$CURRENT_THEME_SYMLINK"

notify-send "Switched to theme: $chosen_theme"
# Reload Hyprland and Mako
pkill waybar
hyprctl dispatch exec waybar
hyprctl reload
makoctl reload

