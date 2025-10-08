{ config, pkgs, lib, ... }:

{
  # Ruby gem configuration
  home.file.".gemrc".text = ''
    gem: --no-document
  '';
}
