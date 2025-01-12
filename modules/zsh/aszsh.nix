{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkPackageOption
    mkOption
		mkDefault
    mkIf
    mkMerge
		foldl'
		literalExpression
    ;
  cfg = config.programs.aszsh;
  relToDotDir = file: (if (cfg.dotDir != null) then (cfg.dotDir + "/") else ".zsh/") + file;
  pluginsDir = relToDotDir "plugins";

  pluginModule = types.submodule (
    { config, ... }:
    {
      options = {
        src = mkOption {
          type = types.path;
          description = ''
            Path to the plugin folder.

            Will be added to {env}`fpath` and {env}`PATH`.
          '';
        };

        name = mkOption {
          type = types.str;
          description = ''
            The name of the plugin.

            Don't forget to add {option}`file`
            if the script name does not follow convention.
          '';
        };

        file = mkOption {
          type = types.str;
          description = "The plugin script to source.";
        };
      };

      config.file = mkDefault "${config.name}.plugin.zsh";
    }
  );

in
{
  options.programs.aszsh = {
    enable = mkEnableOption "Anish Sevekari's Z Shell config";
    package = mkPackageOption pkgs "zsh" { };
    plugins = mkOption {
      type = types.listOf pluginModule;
      default = [ ];
      example = literalExpression ''
        				[
        				{
        # will source zsh-autosuggestions.plugin.zsh
        					name = "zsh-autosuggestions";
        					src = pkgs.fetchFromGitHub {
        						owner = "zsh-users";
        						repo = "zsh-autosuggestions";
        						rev = "v0.4.0";
        						sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        					};
        				}
        			{
        				name = "enhancd";
        				file = "init.sh";
        				src = pkgs.fetchFromGitHub {
        					owner = "b4b4r07";
        					repo = "enhancd";
        					rev = "v2.2.1";
        					sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
        				};
        			}
        			]
        				'';
      description = "Plugins to source in {file}`.zshrc`.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.plugins != [ ]) {
      home.file = foldl' (a: b: a // b) { } (
        map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; }) cfg.plugins
      );
    })
  ]);
}
