{
	description = "my first flake";

	inputs = {
		nixpkgs = {url = "github:NixOs/nixpkgs/nixos-24.11";}; # nix
		home-manager.url = "github:nix-community/home-manager/release-24.11"; # home-manager
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
		nixpkgs-master.url = "github:NixOs/nixpkgs/master";

		# app flakes
		spicetify-nix.url = "github:Gerg-L/spicetify-nix";
		ghostty = { url = "github:ghostty-org/ghostty"; }; 

	};

	outputs = { self, 
				nixpkgs, 
				nixpkgs-unstable,
				home-manager,
				spicetify-nix,
				nixpkgs-master,
				ghostty,
				... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			nixosConfigurations = {
				nixos = lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit ghostty;
						nixpkgsUnstable = import nixpkgs-unstable {
							inherit system;
							config.allowUnfree = true;
						};
					};
					modules = [ 
						./nixos/configuration.nix
					];
				};
			};
		homeConfigurations = {
			marko = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {
					inherit spicetify-nix;
					nixpkgsUnstable = import nixpkgs-unstable{
						inherit system;
						config.allofUnfree = true;
					};
					nixpkgsMaster = import nixpkgs-master{
						inherit system;
						config.allofUnfree = true;
					};
				};
				modules = [
					./home.nix
					./spicetify.nix
				];
			};
		};
	};
}
