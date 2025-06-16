{ pkgs, ... }:
{


environment.systemPackages = with pkgs; [
  (writeShellScriptBin "greetd_inu" (builtins.readFile ../../scripts/greetd_inu.sh)) # this is work in progress
  (writeShellScriptBin "hyprland-keybinds" (builtins.readFile ../../scripts/hyprland-keybinds.sh))
  (writeShellScriptBin "hyprworkspaces" (builtins.readFile ../../scripts/hyprworkspaces.sh))
  (writeShellScriptBin "kdeconnect-share" (builtins.readFile ../../scripts/kdeconnect-share.sh))
  (writeShellScriptBin "mic" (builtins.readFile ../../scripts/mic.sh))
  (writeShellScriptBin "network" (builtins.readFile ../../scripts/network.sh))
  (writeShellScriptBin "power-menu" (builtins.readFile ../../scripts/power-menu.sh))
  (writeShellScriptBin "power-profile" (builtins.readFile ../../scripts/power-profile.sh))
  (writeShellScriptBin "sink" (builtins.readFile ../../scripts/sink.sh))
  (writeShellScriptBin "sources" (builtins.readFile ../../scripts/sources.sh))
  (writeShellScriptBin "toggle-mako" (builtins.readFile ../../scripts/toggle-mako.sh))
  (writeShellScriptBin "waybar-kdeconnect" (builtins.readFile ../../scripts/waybar-kdeconnect.sh))
  (writeShellScriptBin "waybar-mako" (builtins.readFile ../../scripts/waybar-mako.sh))
];
}
