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

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "zsh config target exists and is not a symlink: $target" >&2
      exit 1
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
  '';
}
