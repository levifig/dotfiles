{ config, pkgs, lib, ... }:

{
  # Machine-specific configuration for LFX001 (macOS)
  home.username = "levifig";
  home.homeDirectory = "/Users/levifig";

  # Note: Profiles are imported via flake.nix
  # This file only contains machine-specific overrides
  imports = [
    ../platform/darwin-base.nix
  ];

  # ============================================
  # 🔧 CUSTOMIZE: Your Git Identity
  # If you forked this repo, update these values
  # ============================================
  programs.git = {
    settings = {
      user = {
        name = "Levi Figueira";
        email = "me@levifig.com";
      };
    };
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT8O1BCE6d5mjzD+k4VLeCyM5hjZ2kWnAr+p7XlMsmy";
  };
  # ============================================

  # Machine-specific packages
  home.packages = with pkgs; [
    # macOS specific tools
    m-cli  # Swiss Army Knife for macOS

    # Development tools specific to this machine
    gh  # GitHub CLI
    lazydocker  # Docker TUI

    # Additional utilities
    speedtest-cli
    yt-dlp  # Modern youtube-dl replacement
    tldr
  ];

  # Git configuration is handled by userInfo above
  # Additional git config can be added here if needed

  # SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      # Default settings for all hosts
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 120;
        controlMaster = "auto";
        controlPath = "~/.ssh/control/%C";
        controlPersist = "10m";
      };

      # Personal servers
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/levifig-ed25519";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/keys/levifig-ed25519";
      };

      # Add your personal servers here
      # "myserver" = {
      #   hostname = "server.example.com";
      #   user = "levifig";
      #   identityFile = "~/.ssh/id_ed25519";
      #   port = 22;
      # };
    };
  };

  # Machine-specific environment variables
  home.sessionVariables = {
    # Development paths
    DEVELOPMENT = "$HOME/Development";
    PROJECTS = "$HOME/Development/Projects";

    # Tool-specific
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";  # If using Colima

    # Custom paths
    DOTFILES = "$HOME/.dotfiles";
  };

  # Note: Shell aliases are centralized in modules/shell/aliases.nix
  # Machine-specific aliases can be added here if needed

  # Zsh extra configuration for this machine
  programs.zsh.initContent = lib.mkAfter ''
    # Machine-specific ZSH configuration

    # Load work-specific configuration if it exists
    [[ -f ~/.zshrc.work ]] && source ~/.zshrc.work

    # Custom functions
    function mkcd() {
      mkdir -p "$@" && cd "$@"
    }

    function backup() {
      cp -r "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"
    }

    # 1Password CLI (if using)
    # eval "$(op completion zsh)"; compdef _op op
  '';

  # Starship prompt customization for this machine
  programs.starship.settings = {
    # Add machine-specific prompt elements
    custom.machine = {
      command = "echo 🖥️";
      when = "true";
      format = "[$output](bold blue) ";
    };
  };

  # Home Manager release version
  home.stateVersion = "23.11";
}
