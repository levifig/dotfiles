{ config, pkgs, lib, ... }:

{
  # Basic Bash configuration for server environments
  # Note: Shell aliases are centralized in modules/shell/aliases.nix
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Basic bash configuration
    initExtra = ''
      # History settings
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s histappend

      # Better prompt
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    '';
  };
}
