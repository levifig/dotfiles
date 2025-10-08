{ config, pkgs, lib, ... }:

{
  # This module is deprecated - use modules/shell/starship.nix instead
  # Keeping only to ensure starship is enabled for profiles that import it
  # The actual configuration is in modules/shell/starship.nix
  programs.starship.enable = true;
}
