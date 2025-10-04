{ config, pkgs, lib, ... }:

{
  # Deploy ZSH configuration from repository
  # Your config is version controlled in config/zsh/

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Session variables
    sessionVariables = {
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    };
  };

  # Deploy your ZSH configuration from the repository
  xdg.configFile."zsh" = {
    source = ../../config/zsh;
    recursive = true;
  };
}