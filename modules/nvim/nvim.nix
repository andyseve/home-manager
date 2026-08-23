{
  config,
  lib,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  localSource = "${repoRoot}/modules/nvim/config";
  storeSource = ./config;
  nvimTarget = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim.enable = true;

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_source=${lib.escapeShellArg localSource}
    store_source=${lib.escapeShellArg storeSource}
    target=${lib.escapeShellArg nvimTarget}

    if [ -f "$local_source/init.lua" ]; then
      source="$local_source"
    else
      source="$store_source"
    fi

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "nvim config target exists and is not a symlink: $target" >&2
      exit 1
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
  '';
}
