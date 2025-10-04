{ config, pkgs, lib, ... }:

{
  # Deploy Starship prompt configuration from repository
  programs.starship.enable = true;

  # Deploy your Starship configuration from the repository
  # Note: Starship looks for config at ~/.config/starship.toml
  xdg.configFile."starship.toml" = {
    source = ../../config/starship/starship.toml;
  };
}
