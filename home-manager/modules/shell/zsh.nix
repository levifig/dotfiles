{ config, pkgs, lib, ... }:

{
  # Deploy ZSH configuration from repository
  # Your config is version controlled in config/zsh/

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # History file location (XDG compliant)
    history = {
      path = "${config.xdg.stateHome}/zsh/zsh_history";
      size = 50000;
      save = 50000;
    };

    # Session variables
    sessionVariables = {
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    };

    # ZSH plugins
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };

  # Deploy your ZSH configuration from the repository
  xdg.configFile."zsh" = {
    source = ../../../config/zsh;
    recursive = true;
  };
}