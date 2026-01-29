{ pkgs, ... }: {
  programs.zsh.enable = false;

  programs.aszsh = {
    enable = true;
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
    ];
  };

  home.packages = [ pkgs.zsh ];
}
