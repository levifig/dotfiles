{ config, lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  xdg.configFile."i3/config" = {
    source = ../../../config/i3/config;
  };

  home.packages = with pkgs; [
    i3
    i3status
  ];
}
