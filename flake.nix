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
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    inputs:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

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
            inherit hostConfig;
          };
          modules = inputs.nixos-config.utils.listModules (toString ./modules);
        };
      };
    in
    rec {
      packages = forAllSystems (
        system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
        in
        {
          zsh = pkgs.writeShellApplication {
            name = "zsh";
            runtimeInputs = [
              pkgs.git
              pkgs.zsh
            ];
            text = ''
              local_config="$HOME/.config/home-manager/modules/zsh/config"
              if [[ -f "$local_config/.zshrc" ]]; then
                export ZDOTDIR="$local_config"
              else
                export ZDOTDIR=${./modules/zsh/config}
              fi

              exec ${pkgs.zsh}/bin/zsh "$@"
            '';
          };

          nvim = pkgs.writeShellApplication {
            name = "nvim";
            runtimeInputs = [
              pkgs.git
              pkgs.neovim
            ];
            text = ''
              local_config="$HOME/.config/home-manager/modules/nvim/config"
              if [[ -f "$local_config/init.lua" ]]; then
                export AS_NVIM_CONFIG="$local_config"
              else
                export AS_NVIM_CONFIG=${./modules/nvim/config}
              fi

              exec ${pkgs.neovim}/bin/nvim \
                --cmd "execute \"set runtimepath^=\" . fnameescape(\$AS_NVIM_CONFIG)" \
                -u "$AS_NVIM_CONFIG/init.lua" \
                "$@"
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${packages.${system}.zsh}/bin/zsh";
        };
        zsh = {
          type = "app";
          program = "${packages.${system}.zsh}/bin/zsh";
        };
        nvim = {
          type = "app";
          program = "${packages.${system}.nvim}/bin/nvim";
        };
      });

      hostnames = inputs.nixos-config.hostnames;
      homeConfigurations = inputs.nixpkgs.lib.mapAttrs' mkHost inputs.nixos-config.hostConfigs;
      homeModules = {
        default = ./modules/default.nix;
        kitty = ./modules/kitty/kitty.nix;
        nvim = ./modules/nvim/nvim.nix;
        vscode = ./modules/vscode/vscode.nix;
        zsh = ./modules/zsh/zsh.nix;
      };
      formatter = inputs.nixos-config.formatter;
    };
}
