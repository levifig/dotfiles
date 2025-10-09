{ config, pkgs, lib, ... }:

{
  # Deploy Ghostty configuration from repository
  xdg.configFile."ghostty" = {
    source = ../../../config/ghostty;
    recursive = true;
  };
}
