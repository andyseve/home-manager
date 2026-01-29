{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  nvimSource = "${repoRoot}/modules/nvim/config";
  nvimTarget = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim.enable = true;
  programs.neovim.package = pkgs.neovim;

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg nvimSource} ]; then
      echo "nvim config source missing: ${nvimSource}" >&2
      exit 1
    fi
    mkdir -p "$(dirname ${lib.escapeShellArg nvimTarget})"
    ln -sfn ${lib.escapeShellArg nvimSource} ${lib.escapeShellArg nvimTarget}
  '';
}
