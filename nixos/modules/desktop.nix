{ pkgs, nixpkgsUnstable, ...}:

{

# Enable the X11 windowing system.
	services.xserver.enable = false;
	services.displayManager.enable = false;
	services.displayManager.sddm.wayland.enable = false;
	services.greetd.enable = false;
	services.greetd.settings = {
		default_session = {
			command = "greetd_inu";
			user = "greeter";
		};
	};


    services.udisks2.enable = true;

	environment.etc."issue".text = "
        #@@-                                       
       @@@G@@@:              ▗▄▄▄▄    ▄▄▄▖         
      .@@GGGGG@@@..           ▜███▙  ▟███▛         
      .@@G#####GG@@@@:         ▜███▙▟███▛          
      .@@G%####GGGG@@@@@@@@@@   ▜██████▛           
      .@@GG####GGGGGG@@GGGGG@██▙ ▜████▛     ▟▙     
      .%@GGG###GG@@@GGGGGGGGG███▙ ▜███▙    ▟██▙    
       @@@GGGGGGG@@@@@@@GGGGG      ▜███▙  ▟███▛    
       %@@G@@@@@@@@@@@@@@@@@G       ▜██▛ ▟███▛     
       -@@@@@@@@@@@=* ...@@GG        ▜▛ ▟███▛      
      :*%@@@@@@@@@- |X   @GGG          ▟██████████▙
       #@@@@@@@@@@-     @GGGG         ▟███████████▛
      *@@@@@@@@#######GGGGGGG        ▟███▛         
    -:+@@@@@########&G#/            ▟███▛          
     %@@@@@########G#/  XXXX       ▝▀▀▀▀           
   .#@@@@@########G####\ `'  ████████████████▛     
   =#%@@%#########G######\   ███████████████▛      
     .@@# .:%################     ▜███▙            
       .GG     :###########/       ▜███▙           
       -%GGG    .#######/           ▜███▙          
         +@GG:          _<###▘       ▀▀▀▘          
         .%@@@@%.          ~#
           +@@@@@#*%#:
           :%@@@@@@@@#####%++
            .=#@@@@@@@#######
                =@@@@@@@@####
                      ..::###
					  Hyprland for entering hyprland desktop env
";

	environment.etc."greetd/greetd_inu.sh" = {
		source = ../../scripts/greetd_inu.sh;
		mode = "0755";
	};

# Video drivers & graphics
	services.xserver.videoDrivers = ["amdgpu"];
	hardware.graphics.enable = true; 

# other services
	services.flatpak.enable = true;

# Enable Dbus
	services.dbus.enable = true;
	services.power-profiles-daemon.enable = true;

# Mobile connect
	programs.kdeconnect.enable = true;
	programs.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;

# LOGIN MANAGERS

# ly login
	services.displayManager.ly.enable = false;
	services.displayManager.ly.settings = { 
		vi_mode = true;
		# bg = "0x0024273A";
		border_fg = 6;
		fg = 7;
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

	security.polkit.enable = true;

	programs.waybar.enable = false;

# Wayland & X11 env fixes
	environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
	xdg.portal = { 
		enable = true;
		extraPortals = [
						pkgs.xdg-desktop-portal-gtk
						pkgs.kdePackages.xdg-desktop-portal-kde
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

	fonts.packages = [
		pkgs.nerd-fonts.comic-shanns-mono
	];
}
