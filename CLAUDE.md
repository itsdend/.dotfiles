# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

NixOS + Home Manager dotfiles for a single machine (`x86_64-linux`, hostname `nixos`). The flake manages both OS configuration and a standalone Home Manager installation.

## Key commands

```bash
# Apply Home Manager changes (user-level: terminals, waybar, GTK, etc.)
home-manager switch --flake .

# Apply OS changes (system-level: services, boot, packages in configuration.nix)
sudo nixos-rebuild switch --flake .

# Update all flake inputs
nix flake update

# Enter Erlang dev shell
nix develop .#erlang

# Enter Elixir dev shell
nix develop .#elixir

# List/delete NixOS generations
sudo nixos-rebuild list-generations
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
sudo nix-collect-garbage -d

# List/delete Home Manager generations
home-manager generations
```

## Architecture

The flake (`flake.nix`) is the entry point and wires everything together:

- **`nixos/configuration.nix`** — top-level OS packages (system-wide tools, LSPs, terminals). Imports four modules via `get_modules`.
- **`nixos/modules/core.nix`** — boot, kernel params, networking, locale, timezone, nix settings.
- **`nixos/modules/desktop.nix`** — Hyprland, display managers (ly active, SDDM disabled), PipeWire audio, Bluetooth, XDG portals, fonts.
- **`nixos/modules/users.nix`** — user account definition.
- **`nixos/modules/scripts.nix`** — system scripts exposed as packages.
- **`home.nix`** — standalone Home Manager config: dotfile symlinks, GTK/Qt theming (Catppuccin Mocha Red), bash config with oh-my-posh.
- **`spicetify.nix`** — Spicetify Spotify customization, imported directly into OS config.

### Multiple nixpkgs channels

The flake pins four channels and passes them as `specialArgs`/`extraSpecialArgs`:
- `pkgs` — nixos-26.05 (stable, default)
- `nixpkgsUnstable` — nixos-unstable (used for vivaldi, wezterm, oh-my-posh, watchman)
- `nixpkgsOld` — nixos-25.05
- `nixpkgsMaster` — master branch

When adding packages, pick the channel where the package version you need is available.

### Dev shells

`nixos/shells/erlang/` and `nixos/shells/elixir/` are separate flakes referenced as path inputs. They provide `devShells.x86_64-linux.default` with BEAM tools (erlang/rebar3 and elixir/elixir-ls respectively). The main flake re-exports them as `.#erlang` and `.#elixir`.

### Config files managed by Home Manager

`home.nix` symlinks dotfiles from this repo into `~/.config/` and `~/`. The source files live in:
- `termulator/` — kitty, wezterm, ghostty configs
- `hyper/` — hyprland, hyprlock, hyprpaper configs
- `status/waybar/` — waybar config and CSS
- `mako/` — notification daemon config
- `rofi_run/` — rofi launcher config
- `lsp/` — erlang_ls config
- `xda_apps/` — xsettingsd config

Editing these files and running `home-manager switch --flake .` deploys them.
