{ pkgs, ... }:

{
	home = {
		file = {
			".config/kitty/kitty.conf".source = "${../termulator/kitty/kitty.conf}";
			".config/mako/config".source = "${../mako/config}";
			".wezterm.lua".source = "${../termulator/wezterm/wezterm.lua}";
			".config/rofi/config.rasi".source = "${../rofi_run/config.rasi}";
			".config/ghostty/config".source = "${../termulator/ghostty/config}";
			".config/hypr/hyprland.conf".source = "${../hyper/hyprland.conf}";
			".config/hypr/hyprpaper.conf".source = "${../hyper/hyprpaper.conf}";
			".config/hypr/hyprlock.conf".source = "${../hyper/hyprlock.conf}";
			".config/waybar/config".source = "${../status/waybar/config}";
			".config/waybar/style.css".source = "${../status/waybar/style.css}";
			".config/erlang_ls/erlang_ls.config".source = "${../lsp/erlang_ls.config}";
			".config/xsettingsd/xsettingsd.conf".source = "${../xda_apps/xsettingsd.conf}";
		};

		pointerCursor = {
			gtk.enable = true;
			package = pkgs.catppuccin-cursors.mochaRed;
			size = 24;
			name = "catppuccin-mocha-red-cursors";
		};

		sessionVariables = {};
	};
}
