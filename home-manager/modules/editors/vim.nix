{ config, lib, pkgs, ... }:

{
  xdg.configFile."vim" = {
    source = ../../../config/vim;
    recursive = true;
  };
}
