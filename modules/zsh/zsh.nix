{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  localSource = "${repoRoot}/modules/zsh/config";
  storeSource = ./config;
  zshTarget = "${config.xdg.configHome}/zsh";
  configPaths = [
    ".zshenv"
    ".zshrc"
    "aliases/shortcuts.zsh"
    "aliases/ssh.zsh"
    "aliases/sync.zsh"
    "aliases/taskwarrior.zsh"
    "dircolors"
    "functions/clip.zsh"
    "functions/f.zsh"
    "functions/helper.zsh"
    "functions/latex.zsh"
    "functions/pubsarxiv.zsh"
    "latex/anishs.sty"
    "p10k.zsh"
  ];
in
{
  programs.zsh.enable = true;
  home.packages = [ pkgs.zsh ];

  home.sessionVariables.ZDOTDIR = zshTarget;

  home.activation.linkZshConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_source=${lib.escapeShellArg localSource}
    store_source=${lib.escapeShellArg storeSource}
    target=${lib.escapeShellArg zshTarget}

    if [ -f "$local_source/.zshrc" ]; then
      source="$local_source"
    else
      source="$store_source"
    fi

    replacing_target=false
    if [ -L "$target" ]; then
      replacing_target=true
      $DRY_RUN_CMD rm "$target"
    elif [ -e "$target" ] && [ ! -d "$target" ]; then
      echo "zsh config target exists and is not a directory: $target" >&2
      exit 1
    fi

    $DRY_RUN_CMD mkdir -p "$target"

    for relative_path in ${lib.concatMapStringsSep " " lib.escapeShellArg configPaths}; do
      source_path="$source/$relative_path"
      destination="$target/$relative_path"

      if [ ! -f "$source_path" ]; then
        echo "zsh config source missing: $source_path" >&2
        exit 1
      fi

      if [ "$replacing_target" = false ] && [ -e "$destination" ] && [ ! -L "$destination" ]; then
        echo "zsh config target exists and is not a symlink: $destination" >&2
        exit 1
      fi

      $DRY_RUN_CMD mkdir -p "$(dirname "$destination")"
      $DRY_RUN_CMD ln -sfn "$source_path" "$destination"
    done
  '';
}
