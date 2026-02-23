{
  config,
  lib,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  kittySource = "${repoRoot}/modules/kitty/config";
  kittyTarget = "${config.xdg.configHome}/kitty";
in
{
  home.activation.linkKittyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg kittySource} ]; then
      echo "kitty config source missing: ${kittySource}" >&2
      exit 1
    fi
    mkdir -p "$(dirname ${lib.escapeShellArg kittyTarget})"
    ln -sfn ${lib.escapeShellArg kittySource} ${lib.escapeShellArg kittyTarget}
  '';
}
