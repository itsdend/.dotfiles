{
	description = "my first flake";

	inputs = {
		nixpkgs = {url = "github:NixOs/nixpkgs/nixos-25.11";}; # nix
		home-manager.url = "github:nix-community/home-manager/release-25.11"; # home-manager
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
		nixpkgs-old = {url = "github:NixOs/nixpkgs/nixos-25.05";}; # nix
		nixpkgs-master.url = "github:NixOs/nixpkgs/master";

		# app flakes
		spicetify-nix.url = "github:Gerg-L/spicetify-nix/";
		ghostty = { url = "github:ghostty-org/ghostty"; }; 

	};

	outputs = { self, 
				nixpkgs, 
				nixpkgs-unstable,
				nixpkgs-old,
				nixpkgs-master,
				home-manager,
				spicetify-nix,
				ghostty,
				... }:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
			nixpkgsUnstablePkgs = import nixpkgs-unstable{
				inherit system;
				config.allowUnfree = true;
			};
			nixpkgsOldPkgs = import nixpkgs-old{
				inherit system;
				config.allowUnfree = true;
			};
			nixpkgsMasterPkgs = import nixpkgs-master{
				inherit system;
				config.allowUnfree = true;
			};
			get_modules = {hardwareConfig, extraModules ? []} : [
				hardwareConfig
				./nixos/configuration.nix
				./nixos/modules/core.nix
				./nixos/modules/desktop.nix
				./nixos/modules/users.nix
				./nixos/modules/scripts.nix
				./spicetify.nix
			] ++ extraModules;

		in {
			nixosConfigurations = {
				nixos = lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit spicetify-nix;
						inherit ghostty;
						nixpkgsUnstable = nixpkgsUnstablePkgs;
						nixpkgsMaster = nixpkgsMasterPkgs;
						nixpkgsOld = nixpkgsOldPkgs;
					};
					modules = get_modules {
						hardwareConfig = ./nixos/hardware-configuration.nix;
					};
				};
			};
		homeConfigurations = {
			marko = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {
					nixpkgsUnstable = nixpkgsUnstablePkgs;
				};
				modules = [
					./home.nix
				];
			};
		};
	};
}
