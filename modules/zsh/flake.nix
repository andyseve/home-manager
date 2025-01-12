{
  description = "Z-shell configufation for Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins
    p10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
  };

  outputs = { self, ... }@inputs:
	let
		inherit (inputs.nixpkgs.lib.lists) foldl;
		systems = [ "aarch64_darwin" "x86_64-linux" ];
		pluginPackage = system: plugin: let
			stdenv = inputs.nixpkgs.legacyPackages.${system}.stdenvNoCC;	
		in stdenv.mkDerivation {
			name = "zsh_plugin_" + plugin;
			src = inputs.${plugin};
			buildInputs = [ inputs.nixpkgs.legacyPackages.${system}.zsh ];
			phases = [ "buildPhase" ];
			buildPhase = ''
				zsh -c "echo xdddd"
				zsh -c "zcompile $src/*.zsh"
				touch $src/test
				cp -r $src $out
			'';
		};
		plugins = [ "p10k" ];
	in inputs.flake-utils.lib.eachDefaultSystem ( system: {

		packages = foldl (plugacc: plugin:
			plugacc // { ${plugin} = pluginPackage system plugin; }
		) {} plugins;

	}) // inputs.flake-utils.lib.eachDefaultSystemPassThrough ( system: {

		homeModules.default = { config, hostConfig, lib, pkgs, zshConfig, ... } : let
			inherit (inputs.nixpkgs.lib) mkIf mkMerge;
			inherit (inputs.nixpkgs.lib.lists) foldl;
			# plugins = zshConfig.plugins or plugins;
		in {
			config = mkIf true (mkMerge [
				( mkIf (plugins != []) {
					home.file =
						# foldl (acc: plugin: acc // { ".testdir/plugins/${plugin}".source = inputs.${plugin}; }) {} plugins;
						foldl (acc: plugin: acc // { ".testdir/plugins/${plugin}".source = self.packages.${hostConfig.system}.${plugin}; }) {} plugins;
				})
			]);
		};

		nixosModules.default = {config, lib, pkgs, zshConfig, ... } : let
			plugins = zshConfig.plugins or plugins;
		in {
		};

	});
}
