{ config, lib, ... }:
{
	programs.aszsh = {
		enable = true;
		dotDir = ".config/zsh";

		plugins = [
			{
				name = "zsh-autosuggestions";
				src = pkgs.fetchFromGitHub {
					owner = "zsh-users";
					repo = "zsh-autosuggestions";
					rev = 
				};
			}
		];
	};
}
