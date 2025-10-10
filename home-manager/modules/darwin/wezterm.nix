{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."wezterm" = {
    source = ../../../config/wezterm;
    recursive = true;
  };
}
