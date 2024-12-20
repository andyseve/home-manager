{
  description = "Home Manager configuration of stranger";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://cache.nixos.org https://nix-community.cachix.org https://cuda-maintainers.cachix.org https://hyprland.cachix.org";
    trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
  };

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
      formatter = builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value =
            (inputs.treefmt-nix.lib.evalModule (inputs.nixpkgs.legacyPackages.${system}) ./treefmt.nix)
            .config.build.wrapper;
        }) inputs.nixos-config.systems
      );
    };
}
