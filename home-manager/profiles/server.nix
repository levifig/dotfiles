{ config, pkgs, lib, ... }:

{
  # Server profile - Minimal configuration for VPS and remote servers
  # Provides essential tools without heavy development dependencies

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
    vim  # Basic vim, not neovim
    tmux
    htop
    tree
    rsync
    unzip
    zip

    # Network tools
    nmap
    mtr
    netcat
    iperf3

    # System monitoring
    duf
    ncdu
    btop

    # Text processing
    jq
    yq-go
    ripgrep

    # Security
    gnupg
    openssh
  ];

  # Basic shell aliases
  home.shellAliases = {
    ll = "ls -lah";
    la = "ls -A";
    l = "ls -CF";
    ".." = "cd ..";
    "..." = "cd ../..";
  };

  # Minimal environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    PAGER = "less";
  };

  # Import basic modules
  imports = [
    ../modules/shell/bash.nix
    ../modules/git/config.nix
  ];
}
