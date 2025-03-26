{ pkgs, ... }:
{
  # structure - add extensions separately and configure the .vscode dir
  # through home manager. It would be best if there is some way to
  # automatically create vscode dirs per project that the global config since
  # the global config does nothing but clutter data.
  home.packages = [ pkgs.vscode ];
  home.programs.vscode = {
  	enable = true;
  };
}
