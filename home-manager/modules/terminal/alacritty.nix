{ config, pkgs, lib, ... }:

{
  # Deploy Alacritty configuration from repository
  programs.alacritty.enable = true;

  # Deploy your Alacritty configuration from the repository
  xdg.configFile."alacritty" = {
    source = ../../config/alacritty;
    recursive = true;
  };
}
