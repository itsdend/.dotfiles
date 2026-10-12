{
  description = "Elixir";

  inputs = {
    nixpkgs = {url = "github:NixOs/nixpkgs/nixos-26.05";};
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "elixir-shell";
        buildInputs = [
          pkgs.beam28Packages.elixir
          pkgs.beam28Packages.hex
          pkgs.beam28Packages.elixir-ls
          pkgs.beam28Packages.erlang
        ];
        shellHook = ''
          export PATH="$PATH:/run/current-system/sw/bin"
          printf '\033]1337;SetUserVar=NIX_SHELL=%s\007' "$(printf 'elixir' | base64)"
          trap 'printf "\033]1337;SetUserVar=NIX_SHELL=%s\007" "$(printf "" | base64)"' EXIT
        '';
      };
    };
}
