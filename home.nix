{ pkgs,nixpkgsUnstable, ... }:

{
	home= { 
		username = "marko";

		homeDirectory = "/home/marko";

		stateVersion = "24.11"; # Please read the comment before changing.

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
			gtk-im-module="fcitx";
		};
		gtk4.extraConfig = {
			gtk-application-prefer-dark-theme=1;
			gtk-decoration-layout="icon:minimize,maximize,close";
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
			bashrcExtra = "
				eval \"$(oh-my-posh init bash --config ~/.dotfiles/ohmyposh/larserikfinhold.omp.json)\"
				export XCURSOR_THEME=\"catppuccin-mocha-red-cursors\"
				export PATH=\"$PATH:$HOME/projects/open-source/nixpkgs/result/bin\"
				unset GTK_IM_MODULE
				export QT_IM_MODULE=fcitx5
				export XMODIFIERS=\"@im=fcitx5\"
				export SDL_IM_MODULE=fcitx5
				export GLFW_IM_MODULE=fcitx5
				export QT_QPA_PLATFORMTHEME=qt6ct
				set -o vi
				export EDITOR=nvim
				";
			initExtra = "";
			profileExtra = "";
# TODO nixpkgs/result/bin is used for erlang_ls 1.0.0, when that version come live delete line 130

#export PATH=\"$HOME/nix/store/v6fmqcz4y2vpykiym0igd7n81g1bmxyz-erlang-ls-1.0.0/bin:$PATH\"
# add this in bash for git built erlang_ls
#export PATH=\"$HOME/LSP/bin:$PATH\"
		};
		home-manager.enable = true;
	};
}
