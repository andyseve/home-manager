{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  localSource = "${repoRoot}/modules/kitty/config";
  storeSource = ./config;
  kittyTarget = "${config.xdg.configHome}/kitty";
in
{
  home.packages = [ pkgs.kitty ];

  home.activation.linkKittyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_source=${lib.escapeShellArg localSource}
    store_source=${lib.escapeShellArg storeSource}
    target=${lib.escapeShellArg kittyTarget}

    if [ -f "$local_source/kitty.conf" ]; then
      source="$local_source"
    else
      source="$store_source"
    fi

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "kitty config target exists and is not a symlink: $target" >&2
      exit 1
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
  '';
}
