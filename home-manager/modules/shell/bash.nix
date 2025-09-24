{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    # History control
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.xdg.dataHome}/bash/history";
    historyFileSize = 100000;
    historySize = 10000;

    # Session variables (bash-specific)
    sessionVariables = {
      # Colored GCC warnings and errors
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
    };

    # Shell options
    shellOptions = [
      "histappend"  # Append to history file
      "checkwinsize" # Check window size after each command
      "extglob"     # Extended globs
      "globstar"    # ** recursive matching
      "checkjobs"   # Warn about running jobs when exiting
    ];

    # Bash-specific aliases
    shellAliases = {
      # Reload bash config
      rebash = "source ~/.bashrc";
    };

    # Init commands
    bashrcExtra = ''
      # Better tab completion
      bind "set completion-ignore-case on"
      bind "set show-all-if-ambiguous on"

      # History search
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      # Prompt
      if [ -z "$STARSHIP_SHELL" ]; then
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      fi

      # FZF configuration
      if command -v fzf >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      fi

      # Load local configuration if it exists
      [[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
    '';

    # Profile extra commands (for login shells)
    profileExtra = ''
      # Add local bin to PATH
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}