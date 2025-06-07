{ pkgs, ...}:

{
# Users
	users.users.marko = {
		isNormalUser = true;
		description = "marko";
		extraGroups = [ "networkmanager" "wheel" "wireshark"];
	};

# Programs that require user permissions
	programs.wireshark.enable = true;

# Install firefox.
	programs.firefox.enable = true;

# Shell
	environment.shells = with pkgs; [ bash ];
	users.defaultUserShell = pkgs.bash;
}
