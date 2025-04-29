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
#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
#	networking.wireless.networks = {
#		"t18_deco" = {
#			pskRaw = "0207f26b35fea9327883ab92ebec77974e9ae60afaa4c70bdf201944f0fe6253";
#		};
#	};

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
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		vivaldi
		(catppuccin-sddm.override {
			 flavor = "mocha";
			 font = "ComicShannsMono Nerd Font";
			 fontSize = "15";
#customBackground = true;
			 background = "${./wallpapers/mks_color_ver2.png}";
			 loginBackground = false;
		})
		gcc
		waybar
		rofi-wayland
		wayland-utils
		xorg.xrandr
		wezterm 
		ghostty.packages.${pkgs.system}.default
		neofetch
		wget
		ibus
		git
		wireplumber
		pa-notify
		networkmanagerapplet
		lua-language-server
		swww
		libstdcxx5
		nil
		pavucontrol
		playerctl
		nodejs_22
		corepack_22
		nodePackages_latest.bash-language-server
		vscode-langservers-extracted
		vim-language-server
		xsettingsd
		dot-language-server
		hyprpaper
		hyprlock
		kitty
		hyprcursor
		catppuccin-cursors.mochaRed
		qmk
		via
		wl-clipboard
		thunderbird
		ripgrep
		devbox
		libnotify
		mako
		wireshark
		libsecret
		fastfetch
		];

	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
	];

	services.dbus.enable = true;
	services.xserver.videoDrivers = ["amdgpu"];
	hardware.graphics = {
		enable = true;
	};
	hardware.keyboard.qmk.enable = true;
	services.udev.packages = [pkgs.via];
#services.xserver.displayManager.lightdm.enable = true;



 environment.etc."X11/xorg.conf.d/20-monitor.conf" = {
    text = ''

Section "Monitor"
  Identifier "DisplayPort-9"
  Modeline "2560x1440" 241.50  2560 2720 2992 3424  1440 1443 1453 1481 -hsync +vsync
EndSection

Section "Screen"
  Identifier "Screen0"
  Monitor "DisplayPort-9"
  DefaultDepth 24
  SubSection "Display"
    Depth 24
    Modes "2560x1440"
  EndSubSection
EndSection
    '';
  };

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
	system.stateVersion = "24.05"; # Did you read the comment?

	nix.settings.experimental-features = [ "nix-command" "flakes"];

	services.logind.lidSwitch = "ignore";
	services.logind.lidSwitchExternalPower= "ignore";
	services.logind.lidSwitchDocked="ignore";
	services.flatpak.enable = true;
}
