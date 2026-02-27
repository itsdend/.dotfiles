{ pkgs,ghostty,nixpkgsUnstable,nixpkgsMaster,nixpkgsOld, ... }:

{
	# imports =
	# 	[ # Include the results of the hardware scan.
	# 	./hardware-configuration.nix
	# 	./modules/core.nix
	# 	./modules/desktop.nix
	# 	./modules/users.nix
	# 	];

	environment.systemPackages = with pkgs; [

		#file explorer
		kdePackages.dolphin
		kdePackages.sddm
		pulseaudio

		# browsers
		nixpkgsUnstable.vivaldi

		# messages
		nixpkgsUnstable.signal-desktop

		# login
		(catppuccin-sddm.override {
			 flavor = "mocha";
			 font = "ComicShannsMono Nerd Font";
			 fontSize = "15";
			 background = "${../wallpapers/mks_color_ver2.png}";
			 loginBackground = false;
		})
		ly
		tuigreet

		# status bar
		waybar

		# runner
		rofi

		# wayland
		wayland-utils

		# terminals
		nixpkgsUnstable.wezterm 
		ghostty.packages.${system}.default
		kitty

		# sound
		wireplumber
		pa-notify
		
		# network
		networkmanagerapplet

		# random
		swww 				# dynamic wallpapers
		libgcc 			# c++ compiler
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
		unixODBC
		luajitPackages.lua-lsp
		clang-tools
		clang
		cmake
		boost
		nixpkgsOld.beam27Packages.erlang-ls
		nixpkgsUnstable.beam28Packages.erlang
		nixpkgsUnstable.beam28Packages.rebar3

		# hyprstuff
		hyprpaper
		hyprland
		hyprlock 			# lock screen
		hyprcursor			# cursor
		hyprpolkitagent
		pamtester

		# themes
		catppuccin-cursors.mochaRed
		catppuccin-cursors.mochaMauve
		nixpkgsUnstable.oh-my-posh

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
		fzf

		# editors
		vim
		neovim
		vscode

		# Docs edit
		libreoffice
		
		# system info
		fastfetch

		# qt
		libsForQt5.qt5ct
		kdePackages.qt6ct
		libsForQt5.qtstyleplugin-kvantum
		qt6Packages.qtstyleplugin-kvantum

		# external hdd
		udisks2
		exfatprogs

		# common tools
		wl-clipboard
		cliphist
		zip
		unzip
		jq
		brightnessctl
		inotify-tools
		

		mesa
  		vulkan-tools
  		vulkan-loader
  		libva

		nixpkgsUnstable.erlang-language-platform
		nixpkgsUnstable.watchman

		bolt
		fwupd
		];
}
