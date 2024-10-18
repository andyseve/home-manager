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
		zsh-completions
		zsh-autocomplete
		zsh-autosuggestions
		zsh-syntax-highlighting
	];
in {
	home.packages = dependencies;
	programs.zsh = {
		enable = true;
		autosuggestion.enable = true;
		enableCompletion = true;
		dotDir = ".config/zsh";

		history = {
			# append = true;
			expireDuplicatesFirst = true;
			extended = true;
			ignoreDups = true;
			ignorePatterns = [ "rm *" ];
			path = "${config.xdg.dataHome}/zsh/zsh_history";
			share = false;
		};
	};
}
