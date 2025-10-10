{ config, lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  xdg.configFile."polybar/config.ini" = {
    source = ../../../config/polybar/config.ini;
  };

  home.packages = with pkgs; [
    polybar
  ];
}
