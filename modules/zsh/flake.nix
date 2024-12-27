{
  description = "Z-shell configufation for Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/releaase-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins
    p10k.url = "github:romkatv/powerlevel10k";
  };

  outputs = inputs: {
    # homeModules.zsh = 
  };
}
