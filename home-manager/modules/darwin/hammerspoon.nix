{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."hammerspoon" = {
    source = ../../../config/hammerspoon;
    recursive = true;
  };
}
