{
   description = "my first flake";
   
   inputs = {
      nixpkgs = {
         url = "github:NixOs/nixpkgs/nixos-24.05";
      };
	home-manager.url = "github:nix-community/home-manager/release-24.05";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
   };

   outputs = { self, nixpkgs, home-manager, ... }:
     let lib = nixpkgs.lib;
	system = "x86_64-linux";
	pkgs = nixpkgs.legacyPackages.${system};
     in
 {
      nixosConfigurations = {
          nixos = lib.nixosSystem {
             inherit system;
             modules = [ ./configuration.nix ];
          };
      };
 	homeConfigurations = {
		marko = home-manager.lib.homeManagerConfiguration {
		inherit pkgs;
		modules = [./home.nix];
		};
	};
   };
}
