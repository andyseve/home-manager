{ config, pkgs, ... }:
let
	dependencies = with pkgs; [
		bat
		btop
		coreutils
		curl
		direnv
		eza
		fzf
		git
		less
		ripgrep
		silver-searcher
		zsh
		zsh-powerlevel10k
		zsh-completions
		zsh-autocomplete
		zsh-autosuggestions
		zsh-syntax-highlighting
	];
in rec {
	home.packages = dependencies;
	programs.zsh = {
		enable = true;
		dotDir = ".config/zsh";
	};
	# Link files
	home.activation.linkZsh = config.lib.dag.entryAfter ["writeBoundary"] ''
		ln -sf ${toString ./.zshrc} ~/${programs.zsh.dotDir}/.zshrc
		ln -s ${toString ./p10k.zsh} ~/${programs.zsh.dotDir}/p10k.zsh
	'';
}
