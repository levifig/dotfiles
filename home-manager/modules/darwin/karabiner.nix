{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."karabiner" = {
    source = ../../../config/karabiner;
    recursive = true;
  };
}
