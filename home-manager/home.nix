{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG compliance
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Base packages for all systems
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk

    # Essential tools
    curl
    wget
    git
    tmux
    neovim

    # Search and file tools
    ripgrep
    fd
    fzf
    tree
    bat
    eza

    # JSON/YAML/Data tools
    jq
    yq

    # Archive tools
    zip
    unzip

    # Monitoring
    htop
    btop

    # Network tools
    openssh
    rsync

    # Development basics
    gnumake
    gcc
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";

    # XDG Base Directories
    XDG_CONFIG_HOME = "${config.xdg.configHome}";
    XDG_DATA_HOME = "${config.xdg.dataHome}";
    XDG_CACHE_HOME = "${config.xdg.cacheHome}";
    XDG_STATE_HOME = "${config.xdg.stateHome}";
  };

  # Shell aliases (works across shells)
  home.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # ls replacements
    ls = "eza";
    ll = "eza -la";
    la = "eza -a";
    lt = "eza --tree";

    # Safety nets
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    # Shortcuts
    g = "git";
    v = "nvim";
    t = "tmux";

    # Colorize
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";

    # System
    reload = "source ~/.zshrc";

    # Nix specific
    nix-switch = "home-manager switch --flake ~/.dotfiles";
    nix-update = "nix flake update ~/.dotfiles";
  };

  # Import core modules
  imports = [
    ./modules/core/git.nix
    ./modules/shell/zsh.nix
    ./modules/shell/bash.nix
    ./modules/shell/starship.nix
    ./modules/terminal/tmux.nix
    ./modules/terminal/alacritty.nix
    ./modules/editors/nvim.nix
  ];
}