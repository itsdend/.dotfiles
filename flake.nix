{
	description = "my first flake";

	inputs = {
		nixpkgs = {
			url = "github:NixOs/nixpkgs/nixos-24.05";
		};
		nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager/release-24.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
#		spicetify-nix.url = "github:the-argus/spicetify-nix";
	};

	outputs = { self, nixpkgs, nixpkgs-unstable,home-manager,... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			nixosConfigurations = {
				nixos = lib.nixosSystem {
					inherit system;
					specialArgs = {
						nixpkgsUnstable = import nixpkgs-unstable{
							inherit system;
							config.allofUnfree = true;
						};
					};
					modules = [ 
						./configuration.nix
					];
				};
			};
		homeConfigurations = {
			marko = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				#extraSpecialArgs = {inherit spicetify-nix;};
				modules = [
					./home.nix
#						./spicetify.nix
				];
			};
		};
	};
}
