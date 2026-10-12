{ pkgs, nixpkgsUnstable, ... }:

{
	imports = [
		./home/files.nix
		./home/theming.nix
		./home/shell.nix
	];

	home = {
		username = "marko";
		homeDirectory = "/home/marko";
		stateVersion = "26.05"; # Please read the comment before changing.
	};

	programs.home-manager.enable = true;
}
