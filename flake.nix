{
  description = "Home Manager configuration for Anish Sevekari";

  inputs = {
    # Tie inputs to ones defined in nixos configuration
    nixos-config.url = "github:andyseve/nixos";
    nixpkgs.follows = "nixos-config/nixpkgs";
    unstable.follows = "nixos-config/unstable";
    treefmt-nix.follows = "nixos-config/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Manages configs and home directory
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      mkHost = host: hostConfig: {
        name = "stranger@${host}";
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          extraSpecialArgs = {
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
          };
          modules = inputs.nixos-config.utils.listModules' (toString ./modules);
        };
      };
    in
    rec {
      hostnames = inputs.nixos-config.hostnames;
      homeConfigurations = inputs.nixpkgs.lib.mapAttrs' mkHost inputs.nixos-config.hostConfigs;
      formatter = inputs.nixos-config.formatter;
    };
}
