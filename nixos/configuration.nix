# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,ghostty,nixpkgsUnstable, ... }:

#let
# Import the unstable nixos channel

#cus_vivaldi = pkgs.vivaldi.overrideAttrs (oldAttrs: {
#	dontWrapQtApps = false;
#dontPatchELF = true;
#	nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
#	});

#in

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		./modules/core.nix
		./modules/desktop.nix
		./modules/users.nix
		];



# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;








# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
#cus_vivaldi
#	(vivaldi.overrideAttrs (oldAttrs: {
#  buildInputs = (oldAttrs.buildInputs or []) ++ [
#    pkgs.libsForQt5.qtwayland
#    pkgs.libsForQt5.qtx11extras
#    pkgs.kdePackages.plasma-integration.qt5
#    pkgs.kdePackages.kio-extras-kf5
#    pkgs.kdePackages.breeze.qt5
#  ];
#}))
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
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		neovim
		
		# system info
		fastfetch

		# common tools
		wl-clipboard
		cliphist
		zip
		unzip
		];





# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).


	# services

}
