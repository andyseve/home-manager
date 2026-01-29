{ pkgs, ... }: {
  home.username = "stranger";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/stranger" else "/home/stranger";

  # Track the Home Manager release this config was first written against.
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
