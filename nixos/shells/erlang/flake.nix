{
  description = "Invariant Erlang Flake";

  inputs = {
		nixpkgs = {url = "github:NixOs/nixpkgs/nixos-26.05";};
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      elp = pkgs.callPackage ./elp_latest.nix { }; # TODO RM lsps
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "erlang-shell";
        buildInputs = [
          pkgs.beam28Packages.erlang
          pkgs.beam28Packages.rebar3
          pkgs.vips
          pkgs.glibc
          pkgs.file
          elp       #TODO rm lsps 
        ];
        shellHook = ''
            export PATH="$PATH:/run/current-system/sw/bin"
            '';
      };
    };
}
