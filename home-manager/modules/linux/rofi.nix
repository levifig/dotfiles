{ config, lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  xdg.configFile."rofi" = {
    source = ../../../config/rofi;
    recursive = true;
  };

  home.packages = with pkgs; [
    rofi
  ];
}
