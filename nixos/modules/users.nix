{ pkgs, ...}:

{
# Users
	users = {
		users.marko = {
			isNormalUser = true;
			description = "marko";
			extraGroups = [ "networkmanager" "wheel" "wireshark"];
		};
		defaultUserShell = pkgs.bash;
	};

# Programs that require user permissions
	programs = {
		wireshark.enable = true;
		firefox.enable = true;
	};


# Shell
	environment.shells = with pkgs; [ bash ];
}
