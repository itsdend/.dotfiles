{ config, pkgs,nixpkgsUnstable,nixpkgsMaster, ... }:
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

		# messages
		nixpkgsUnstable.signal-desktop

		# spotify
		spicetify-cli

		# lsps
		nil # nix lsp
		unixODBC
		luajitPackages.lua-lsp
		clang-tools
		clang
		cmake
		boost
		#nixpkgsUnstable.erlang-ls this is for now installed manually because the current version is behind erlang 27
		nixpkgsMaster.beam.packages.erlang_27.erlang-ls
		nixpkgsUnstable.erlang_27
		nixpkgsUnstable.beam.packages.erlang_27.rebar3
		#nixpkgsUnstable.elixir-ls

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
		".config/kitty/kitty.conf".source = "${./termulator/kitty/kitty.conf}";
		".config/mako/config".source = "${./mako/config}";
		".wezterm.lua".source = "${./termulator/wezterm/wezterm.lua}";
		".config/rofi/config.rasi".source = "${./rofi_run/config.rasi}";
		".config/ghostty/config".source = "${./termulator/ghostty/config}";
		".config/hypr/hyprland.conf".source = "${./hyper/hyprland.conf}";
		".config/hypr/hyprpaper.conf".source = "${./hyper/hyprpaper.conf}";
		".config/hypr/hyprlock.conf".source = "${./hyper/hyprlock.conf}";
		".config/waybar/config".source = "${./status/waybar/config}";
		".config/waybar/style.css".source = "${./status/waybar/style.css}";
		".config/erlang_ls/erlang_ls.config".source = "${./lsp/erlang_ls.config}";
		".config/xsettingsd/xsettingsd.conf".source = "${./xda_apps/xsettingsd.conf}";
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
	home.pointerCursor.gtk.enable = true;
	home.pointerCursor.package = pkgs.catppuccin-cursors.mochaRed;
	home.pointerCursor.size = 24;
	home.pointerCursor.name = "catppuccin-mocha-red-cursors";
	home.sessionVariables = {
	};
	gtk = {
		enable = true;
		gtk3.extraConfig = {
			gtk-application-prefer-dark-theme=1;
			gtk-decoration-layout=icon:minimize,maximize,close;
			gtk-im-module="fcitx";
		};
		gtk4.extraConfig = {
			gtk-application-prefer-dark-theme=1;
			gtk-decoration-layout=icon:minimize,maximize,close;
			gtk-im-module="fcitx";
		};
		gtk2.extraConfig = 
			"gtk-application-prefer-dark-theme=1
			gtk-decoration-layout = icon:minimize,maximize,close
			gtk-im-module=\"fcitx\";
			";
		font = {
			name = "ComicShannsMono Nerd Font bold 15";
		};
		iconTheme = {
			package = (pkgs.catppuccin-papirus-folders.override { flavor = "mocha"; accent = "peach"; });
			name  = "Papirus-Dark";
		};
	};

	programs.bash.bashrcExtra = "eval \"$(oh-my-posh init bash --config ~/.dotfiles/ohmyposh/larserikfinhold.omp.json)\"
		export XCURSOR_THEME=\"catppuccin-mocha-red-cursors\"
		export PATH=\"$PATH:$HOME/projects/open-source/nixpkgs/result/bin\"
		export GTK_IM_MODULE=fcitx5
		export QT_IM_MODULE=fcitx5
		export XMODIFIERS=\"@im=fcitx5\"
		export SDL_IM_MODULE=fcitx5
		export GLFW_IM_MODULE=fcitx5
		set -o vi
		export EDITOR=nvim
		";
		# TODO nixpkgs/result/bin is used for erlang_ls 1.0.0, when that version come live delete line 130

   	#export PATH=\"$HOME/nix/store/v6fmqcz4y2vpykiym0igd7n81g1bmxyz-erlang-ls-1.0.0/bin:$PATH\"
		# add this in bash for git built erlang_ls
	#export PATH=\"$HOME/LSP/bin:$PATH\"

	programs.bash.enable = true;
# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
