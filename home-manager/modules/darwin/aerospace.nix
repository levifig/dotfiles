{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."aerospace" = {
    source = ../../../config/aerospace;
    recursive = true;
  };
}
