{ config, pkgs, lib, ... }:

{
  # Use existing ZSH configuration from ~/.config/zsh
  # This preserves your current setup without modification

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Minimal session variables
    sessionVariables = {
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    };
  };

  # Link to your existing ZSH configuration
  # This keeps your current config exactly as-is
  xdg.configFile."zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/zsh";
    recursive = true;
  };

  # Ensure .zshenv points to XDG directory
  home.file.".zshenv".text = ''
    # Set ZDOTDIR to use XDG-compliant location
    export ZDOTDIR="$HOME/.config/zsh"

    # Source the main zshrc if it exists
    [[ -f "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"
  '';
}