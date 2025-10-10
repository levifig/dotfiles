{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  # Deploy yabairc to home directory
  home.file.".yabairc" = {
    source = ../../../config/yabai/yabairc;
    executable = true;
  };

  # Deploy skhdrc to home directory
  home.file.".skhdrc" = {
    source = ../../../config/skhd/skhdrc;
    executable = true;
  };
}
