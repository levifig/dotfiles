{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    # Enable completions
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History configuration
    history = {
      size = 100000;
      save = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
    };

    # Session variables (zsh-specific)
    sessionVariables = {
      # Ensure XDG dirs are set
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    };

    # Oh-My-Zsh configuration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # Will be overridden by starship
      plugins = [
        "git"
        "docker"
        "kubectl"
        "terraform"
        "aws"
        "fzf"
        "z"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "sudo"
      ];
    };

    # Additional init commands
    initExtra = ''
      # Key bindings
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # Options
      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_BEEP
      setopt SHARE_HISTORY
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt AUTO_MENU
      setopt AUTO_CD
      setopt CORRECT
      setopt INTERACTIVE_COMMENTS
      setopt GLOB_DOTS

      # FZF configuration
      if command -v fzf >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_DEFAULT_OPTS='
          --height 40%
          --layout=reverse
          --border
          --preview-window=:hidden
          --preview "bat --style=numbers --color=always --line-range :500 {}"
          --bind="ctrl-p:toggle-preview"
        '
      fi

      # Load local configuration if it exists
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';

    # Prezto configuration (alternative to oh-my-zsh, disabled by default)
    # prezto = {
    #   enable = false;
    #   pmodules = [
    #     "environment"
    #     "terminal"
    #     "editor"
    #     "history"
    #     "directory"
    #     "spectrum"
    #     "utility"
    #     "completion"
    #     "prompt"
    #     "git"
    #     "syntax-highlighting"
    #     "history-substring-search"
    #     "autosuggestions"
    #   ];
    # };

    # Shell aliases are inherited from home.shellAliases
    shellAliases = {
      # Zsh specific aliases
      zshconfig = "nvim ~/.config/zsh/.zshrc";
      ohmyzsh = "nvim ~/.config/oh-my-zsh";

      # Directory shortcuts
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";
      dev = "cd ~/Development";
    };

    # Plugins from nixpkgs
    plugins = [
      # Removed custom GitHub fetches to avoid hash mismatches
      # oh-my-zsh provides most needed functionality
    ];
  };

  # Create zsh config directory
  xdg.configFile."zsh/.keep".text = "";
}