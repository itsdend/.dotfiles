#!/usr/bin/env bash


CURRENT_THEME_DIR="$HOME/.config/inu_nix/current/theme"

mkdir -p "$HOME/.config/inu_nix/themes"

if [ ! -L ~/.config/inu_nix/themes/current ]; then
    echo "Creating default theme symlink..."
    ln -nsf ~/.dotfiles/themes/pastel_inu_cyber ~/.config/inu_nix/themes/current
  fi

hyprctl reload
makoctl reload
