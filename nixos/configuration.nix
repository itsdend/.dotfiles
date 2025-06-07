{ pkgs,ghostty,nixpkgsUnstable, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		./modules/core.nix
		./modules/desktop.nix
		./modules/users.nix
		];

	environment.systemPackages = with pkgs; [

		#file explorer
		kdePackages.dolphin
		kdePackages.sddm
		pulseaudio

		# browsers
		vivaldi

		nixpkgsUnstable.spicetify-cli

		# login
		(catppuccin-sddm.override {
			 flavor = "mocha";
			 font = "ComicShannsMono Nerd Font";
			 fontSize = "15";
			 background = "${../wallpapers/mks_color_ver2.png}";
			 loginBackground = false;
		})
		nixpkgsUnstable.ly

		# status bar
		waybar

		# runner
		rofi-wayland

		# wayland
		wayland-utils

		# terminals
		wezterm 
		ghostty.packages.${pkgs.system}.default
		kitty

		# sound
		wireplumber
		pa-notify
		
		# network
		networkmanagerapplet

		# random
		swww 				# dynamic wallpapers
		libstdcxx5 			# c++ compiler
		xorg.xrandr 		# screen res
		xsettingsd 			# x11 graphical envs 
		
		# sound
		pavucontrol
		playerctl

		# lsp
		nodejs_22
		corepack_22
		nodePackages_latest.bash-language-server
		vscode-langservers-extracted
		vim-language-server
		dot-language-server
		nil
		lua-language-server
		gcc

		# hyprstuff
		hyprpaper
		hyprlock 			# lock screen
		hyprcursor			# cursor
		hyprpolkitagent

		# themes
		catppuccin-cursors.mochaRed
		oh-my-posh

		# keyboard
		qmk
		via
	
		# e-mails
		thunderbird

		# notify
		libnotify
		mako

		# dev tools
		wireshark
		devbox
		libsecret 			# secure pass manage
		git
		wget				
		ibus				# input method
		lazygit
		ripgrep

		# editors
		vim
		neovim

		# Docs edit
		libreoffice
		
		# system info
		fastfetch

		# common tools
		wl-clipboard
		cliphist
		zip
		unzip
		];

}
