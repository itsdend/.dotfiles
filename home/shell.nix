{ ... }:

{
	programs.bash = {
		enable = true;
		shellAliases = {
			erlang-shell = "nix develop ~/.dotfiles#erlang";
			elixir-shell = "nix develop ~/.dotfiles#elixir";
		};
		bashrcExtra = "
			eval \"$(oh-my-posh init bash --config ~/.config/inu_nix/themes/current/larserikfinhold.omp.json)\"
			export XCURSOR_THEME=\"catppuccin-mocha-red-cursors\"
			export PATH=\"$PATH:$HOME/projects/open-source/nixpkgs/result/bin\"
			set -o vi
			export EDITOR=nvim
			export PATH=\"$HOME/.local/bin:$PATH\"

			";
		initExtra = "";
		profileExtra = "";
	};
}
