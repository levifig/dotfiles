{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  # Deploy hammerspoon config to ~/.hammerspoon/
  home.file.".hammerspoon" = lib.mkIf
    (builtins.pathExists ../../../config/hammerspoon) {
    source = ../../../config/hammerspoon;
    recursive = true;
  };
}
