# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,ghostty, ... }:

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
		];


# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	environment.shells = with pkgs; [ bash ];
	users.defaultUserShell = pkgs.bash;
	networking.hostName = "nixos"; # Define your hostname.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
		networking.networkmanager.enable = true;

# Set your time zone.
	time.timeZone = "Europe/Zagreb";
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; 
		[
			fcitx5-m17n
		];
	};

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "hr_HR.UTF-8";
		LC_IDENTIFICATION = "hr_HR.UTF-8";
		LC_MEASUREMENT = "hr_HR.UTF-8";
		LC_MONETARY = "hr_HR.UTF-8";
		LC_NAME = "hr_HR.UTF-8";
		LC_NUMERIC = "hr_HR.UTF-8";
		LC_PAPER = "hr_HR.UTF-8";
		LC_TELEPHONE = "hr_HR.UTF-8";
		LC_TIME = "hr_HR.UTF-8";
	};

# Enable the X11 windowing system.
# You can disable this if you're only using the Wayland session.
	services.xserver.enable = true;

# Enable the KDE Plasma Desktop Environment.
	services.displayManager.sddm.enable = true;
services.displayManager.sddm.settings = {
	Autologin = {
		Session = "hyprland.desktop";
		User = "marko";
	};
};
	services.desktopManager.plasma6.enable = true;
	services.displayManager.sddm.theme="catppuccin-mocha";


# Enable CUPS to print documents.
	services.printing.enable = true;

# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
	};

# Bluetooth Stuff
	services.blueman.enable = true;
	hardware.bluetooth = {
		enable = true;
		package = pkgs.bluez;
		settings.general = {
			enable = "Source,Sink,Media,Socket";
		};
	};
# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.marko = {
		isNormalUser = true;
		description = "marko";
		extraGroups = [ "networkmanager" "wheel" "wireshark"];
		packages = with pkgs; [
			kdePackages.kate
		];
	};
	programs.wireshark.enable = true;


# Install firefox.
	programs.firefox.enable = true;


# wayland and x11
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

	environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland


# Allow unfree packages
		nixpkgs.config = {
			allowUnfree = true;
		};
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
		# browsers
		vivaldi

		# login
		(catppuccin-sddm.override {
			 flavor = "mocha";
			 font = "ComicShannsMono Nerd Font";
			 fontSize = "15";
			 background = "${./wallpapers/mks_color_ver2.png}";
			 loginBackground = false;
		})

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
		zip
		unzip
		];

	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
	];

	services.dbus.enable = true;
	services.xserver.videoDrivers = ["amdgpu"];
	hardware.graphics = {
		enable = true;
	};

	# keyboard
	hardware.keyboard.qmk.enable = true;
	services.udev.packages = [pkgs.via];


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

	system.stateVersion = "24.11"; # Did you read the comment?
	nix.settings.experimental-features = [ "nix-command" "flakes"];

	# services

	services.logind.lidSwitch = "ignore";
	services.logind.lidSwitchExternalPower= "ignore";
	services.logind.lidSwitchDocked="ignore";
	services.flatpak.enable = true;
}
