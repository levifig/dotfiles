{ config, pkgs, lib, ... }:

{
  # Deploy Git configuration from repository
  programs.git.enable = true;

  # Deploy your Git configuration files from the repository
  xdg.configFile."git/config" = {
    source = ../../../config/git/config;
  };

  xdg.configFile."git/ignore" = {
    source = ../../../config/git/ignore;
  };
}
