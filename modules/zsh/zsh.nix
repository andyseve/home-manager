{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/.config/home-manager";
  zshSource = "${repoRoot}/modules/zsh/config";
  zshTarget = "${config.xdg.configHome}/zsh";
in
{
  programs.zsh.enable = true;
  home.packages = [ pkgs.zsh ];

  home.sessionVariables.ZDOTDIR = zshTarget;

  home.activation.linkZshConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg zshSource} ]; then
      echo "zsh config source missing: ${zshSource}" >&2
      exit 1
    fi
    mkdir -p "$(dirname ${lib.escapeShellArg zshTarget})"
    ln -sfn ${lib.escapeShellArg zshSource} ${lib.escapeShellArg zshTarget}
  '';
}
