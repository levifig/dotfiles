{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."sketchybar" = {
    source = ../../../config/sketchybar;
    recursive = true;
  };
}
