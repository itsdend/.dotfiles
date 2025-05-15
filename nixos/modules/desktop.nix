{ config, pkgs, ...}:

{

# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.displayManager.sddm.wayland.enable = false; # TODO sddm

# Video drivers & graphics
	services.xserver.videoDrivers = ["amdgpu"];
	hardware.graphics.enable = true; 

# other services
	services.flatpak.enable = true;

# Enable Dbus
	services.dbus.enable = true;
	services.power-profiles-daemon.enable = true;

# Plasma enable
	# services.desktopManager.plasma6.enable = true;

# ly login
	services.displayManager.ly.enable = true;
	services.displayManager.ly.settings = { 
		vi_mode = true;
		# bg = "0x0024273A";
		# border_fg = "0x007AC3FF";
		# fg = "0x00EB87B6";
		# error_fg = "0x00FC50B4";
	};

# SDDM login
	services.displayManager.sddm = {
		enable = false;# TODO sddm
		settings = {
			Autologin = {
				Session = "hyprland.desktop";
				User = "marko";
			};
		};
		theme="catppuccin-mocha";
	};
	services.displayManager.defaultSession = "hyprland";
# Hyprland 
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};
	programs.waybar.enable = true;

# Wayland & X11 env fixes
	environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
	xdg.portal = { 
		enable = true;
		extraPortals = [
						pkgs.xdg-desktop-portal-gtk
						pkgs.xdg-desktop-portal-hyprland
						];
		config = {
			common.default = ["gtk"];
			hyprland.default = ["gtk" "hyprland"];
		};
	};
	environment.variables = {
		XCURSOR_THEME = "catppuccin-mocha-red-cursors";
		XCURSOR_SIZE = "24";
	};


# PipeWire audio
	security.rtkit.enable = true;
	hardware.pulseaudio.enable = false;
	services.pipewire = {
	wireplumber.enable = true;
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
	};

# Bluetooth
	services.blueman.enable = true;
	hardware.bluetooth = {
		enable = true;
		package = pkgs.bluez;
		settings.general = {
			enable = "Source,Sink,Media,Socket";
		};
	};

# Enable CUPS to print documents.
	services.printing.enable = true;

# Laptop behavior
	services.logind.lidSwitch = "ignore";
	services.logind.lidSwitchExternalPower= "ignore";
	services.logind.lidSwitchDocked="ignore";

	# keyboard
	hardware.keyboard.qmk.enable = true;
	services.udev.packages = [pkgs.via];

	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
	];
}
