{ pkgs, ... }:

{
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
			name = "Papirus-Dark";
		};
		theme = {
			package = (pkgs.catppuccin-gtk.override { variant = "mocha"; accents = ["red"]; });
			name = "catppuccin-mocha-red-standard";
		};
		cursorTheme = {
			package = (pkgs.catppuccin-cursors.mochaRed);
			size = 24;
			name = "catppuccin-mocha-red-cursors";
		};
	};

	qt = {
		enable = true;
		style = {
			package = (pkgs.catppuccin-kvantum.override { variant = "mocha"; accent = "red"; });
			name = "kvantum";
		};
	};
}
