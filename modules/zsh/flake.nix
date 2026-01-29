{
  description = "Z-shell configuration for Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
  };

  outputs = { self, ... }: {
    homeModules.default =
      { config, ... }:
      let
        mkLink = config.lib.file.mkOutOfStoreSymlink;
        zshDir = toString ./.;
      in
      {
        xdg.configFile."zsh/.zshrc".source = mkLink "${zshDir}/.zshrc";
        xdg.configFile."zsh/.zshenv".source = mkLink "${zshDir}/.zshenv";
        xdg.configFile."zsh/p10k.zsh".source = mkLink "${zshDir}/p10k.zsh";
      };
  };
}
