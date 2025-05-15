{ config, pkgs, ...}:

{ 
# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

# Hostname
	networking.hostName = "nixos"; # Define your hostname.

# Enable networking
	networking.networkmanager.enable = true;

# Locale and input method
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

# input Method
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; 
		[
			fcitx5-m17n
		];
	};

# Timezone
	time.timeZone = "Europe/Zagreb";


# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# Experimental
	nix.settings.experimental-features = [ "nix-command" "flakes"];

# State version
	system.stateVersion = "24.11"; # Did you read the comment?
}
