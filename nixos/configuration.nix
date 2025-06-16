{ pkgs,ghostty,nixpkgsUnstable,nixpkgsMaster, ... }:

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
		vivaldi

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
		greetd.tuigreet

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

		# hyprstuff
		hyprpaper
		hyprlock 			# lock screen
		hyprcursor			# cursor
		hyprpolkitagent
		pamtester

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
		fzf

		# editors
		vim
		neovim

		# Docs edit
		libreoffice
		
		# system info
		fastfetch

		# qt
		libsForQt5.qt5ct
		kdePackages.qt6ct
		libsForQt5.qtstyleplugin-kvantum
		qt6Packages.qtstyleplugin-kvantum

		# common tools
		wl-clipboard
		cliphist
		zip
		unzip
		jq
		];
}
