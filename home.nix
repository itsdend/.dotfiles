{ config, pkgs, ... }:

#let userDotfiles = builtins.path {
#	name = "userDotfiles";
#	path = /home/marko/.dotfiles/termulator/wezterm;
#};
#in 
let
  userDotfiles = {
    term = builtins.path { name = "terminal"; path = /home/marko/.dotfiles/termulator/wezterm; };
    hyprl = builtins.path { name = "hyperland"; path = /home/marko/.dotfiles/hyper; };
    bsh = builtins.path { name = "hyperland"; path = /home/marko/.dotfiles/bash; };
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marko";
  home.homeDirectory = "/home/marko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

#wayland.windowManager.hyperland.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =  with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

	lazygit
    wezterm
	oh-my-posh

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
      ".wezterm.lua".source = "${userDotfiles.term}/.wezterm.lua";
	".config/hypr/hyprland.conf".source = "${userDotfiles.hyprl}/hyprland.conf";
	# ".bashrc".source = "{userDotfiles.bsh}/.bachrc";

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/marko/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

programs.bash.bashrcExtra = "eval \"$(oh-my-posh init bash --config ~/.dotfiles/ohmyposh/larserikfinhold.omp.json)\"";
	programs.bash.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
