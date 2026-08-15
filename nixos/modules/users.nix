{ pkgs, ...}:

{
# Users
	users = {
		users.marko = {
			isNormalUser = true;
			description = "marko";
			extraGroups = [ "networkmanager" "wheel" "wireshark" "audio"];
		};
		defaultUserShell = pkgs.bash;
	};

# Programs that require user permissions
	programs = {
		wireshark.enable = true;
		firefox.enable = true;
		nix-ld.enable = true;
	};


# Shell
	environment.shells = with pkgs; [ bash ];
}
