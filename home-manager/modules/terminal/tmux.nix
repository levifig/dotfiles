{ config, pkgs, lib, ... }:

{
  # Deploy tmux configuration from repository
  programs.tmux.enable = true;

  # Deploy your tmux configuration from the repository
  xdg.configFile."tmux" = {
    source = ../../config/tmux;
    recursive = true;
  };

  # Ensure tmux package is available
  home.packages = with pkgs; [
    tmux
  ];
}
