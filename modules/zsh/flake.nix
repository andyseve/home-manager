{
  description = "Z-shell configuration for Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
  };

  outputs = { self, ... }: {
    homeModules.default =
      {
        config,
        pkgs,
        ...
      }:
      {
        programs.zsh.enable = true;
        home.packages = [ pkgs.zsh ];
        home.sessionVariables.ZDOTDIR = "${config.xdg.configHome}/zsh";

        xdg.configFile."zsh" = {
          source = ./config;
          recursive = true;
        };
      };
  };
}
