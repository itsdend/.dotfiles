{ pkgs,nixpkgsUnstable, ... }:

{
	home= { 
		username = "marko";

		homeDirectory = "/home/marko";

		stateVersion = "26.05"; # Please read the comment before changing.

		file = {
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
		};

		pointerCursor = {
			gtk.enable = true;
			package = pkgs.catppuccin-cursors.mochaRed;
			size = 24;
			name = "catppuccin-mocha-red-cursors";
		};

		sessionVariables = {};

	};

	# cursors
	# change gtk to gtkcursotTheme.....
	gtk = { 
		enable = true;
		gtk3.extraConfig = {
			gtk-application-prefer-dark-theme=1;
			gtk-decoration-layout="icon:minimize,maximize,close";
		};
		gtk4.extraConfig = {
			gtk-application-prefer-dark-theme=1;
			gtk-decoration-layout="icon:minimize,maximize,close";
		};
		gtk2.extraConfig = 
			"gtk-application-prefer-dark-theme=1
			gtk-decoration-layout = icon:minimize,maximize,close
			";
		font = {
			name = "ComicShannsMono Nerd Font bold 15";
		};
		iconTheme = {
			package = (pkgs.catppuccin-papirus-folders.override { flavor = "mocha"; accent = "peach"; });
			name  = "Papirus-Dark";
		};
		theme  = {
			package = (pkgs.catppuccin-gtk.override { variant = "mocha"; accents = ["red"];});
			name = "catppuccin-mocha-red-standard";
		};
		cursorTheme = {
			package = (pkgs.catppuccin-cursors.mochaRed);
			size = 24;
			name =  "catppuccin-mocha-red-cursors";
		};
	};
	qt = {
		enable = true;
		style = {
			package = (pkgs.catppuccin-kvantum.override {variant = "mocha"; accent = "red";});
			name = "kvantum";

		};
	};

	# bash settings

	programs = {
		bash = {
			enable = true;
			shellAliases = {
				erlang-shell = "nix develop ~/.dotfiles#erlang";
				elixir-shell = "nix develop ~/.dotfiles#elixir";
			};
			bashrcExtra = "
				eval \"$(oh-my-posh init bash --config ~/.config/inu_nix/themes/current/larserikfinhold.omp.json)\"
				export XCURSOR_THEME=\"catppuccin-mocha-red-cursors\"
				export PATH=\"$PATH:$HOME/projects/open-source/nixpkgs/result/bin\"
				set -o vi
				export EDITOR=nvim
				export PATH=\"$HOME/.local/bin:$PATH\"
				

				";
			initExtra = "";
			profileExtra = "";
		};
		home-manager.enable = true;
	};
}
