{ pkgs,nixpkgsUnstable, lib, spicetify-nix, ... }:
let
spicePkgs = spicetify-nix.legacyPackages.${nixpkgsUnstable.system};
in
{
# allow spotify to be installed if you don't have unfree enabled already
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"spotify"
	];

# import the flake's module for your system
	imports = [ spicetify-nix.homeManagerModules.default ];

# configure spicetify :)
	programs.spicetify =
	{
		enable = true;
		theme = spicePkgs.themes.catppuccin;
		colorScheme = "mocha";

		spicetifyPackage = nixpkgsUnstable.spicetify-cli;
		spotifyPackage = nixpkgsUnstable.spotify;

		enabledExtensions = with spicePkgs.extensions; [
			keyboardShortcut

		];
	};
}
