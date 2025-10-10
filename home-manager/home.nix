{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Note: allowUnfree is configured in darwin/configuration.nix via useGlobalPkgs

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
    # Note: neovim is configured via modules/editors/nvim.nix

    # Search and file tools
    ripgrep
    fd
    fzf
    tree
    bat
    eza

    # JSON/YAML/Data tools
    jq
    yq-go # Go implementation of yq

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

  # Note: Shell aliases are centralized in modules/shell/aliases.nix

  # Import core modules
  imports = [
    ./modules/core/git.nix
    ./modules/core/xdg.nix
    ./modules/shell/aliases.nix
    ./modules/shell/zsh.nix
    ./modules/shell/bash.nix
    ./modules/shell/starship.nix
    ./modules/terminal/tmux.nix
    ./modules/terminal/alacritty.nix
    ./modules/editors/nvim.nix
    ./modules/editors/vim.nix
    ./modules/editors/zed.nix
    ./modules/tools/ripgrep.nix
    ./modules/tools/claude.nix
    ./modules/tools/opencode.nix
  ];
}
