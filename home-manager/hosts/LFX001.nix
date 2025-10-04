{ config, pkgs, lib, ... }:

{
  # Machine-specific configuration for LFX001 (macOS)
  home.username = "levifig";
  home.homeDirectory = "/Users/levifig";

  # Include platform defaults
  imports = [
    ../platform/darwin-base.nix
    ../profiles/development.nix
    ../profiles/platform.nix
  ];

  # Machine-specific packages
  home.packages = with pkgs; [
    # macOS specific tools
    m-cli  # Swiss Army Knife for macOS

    # Communication
    # slack
    # zoom-us
    # discord

    # Development tools specific to this machine
    gh  # GitHub CLI
    lazydocker  # Docker TUI

    # Additional utilities
    speedtest-cli
    yt-dlp  # Modern youtube-dl replacement
    tldr
  ];

  # Git configuration for this machine
  programs.git = {
    userEmail = lib.mkForce "levi@levifig.com";

    # Signing configuration
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "ssh";
      commit.gpgsign = true;
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;

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
        identityFile = "~/.ssh/id_ed25519";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
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

  # Machine-specific shell aliases
  home.shellAliases = {
    # Quick navigation
    dev = "cd ~/Development";
    proj = "cd ~/Development/Projects";
    dots = "cd ~/.dotfiles";
    conf = "cd ~/.config";

    # System specific
    brewup = "brew update && brew upgrade && brew cleanup";

    # Quick edits
    zshconfig = "nvim ~/.config/zsh/.zshrc";
    nixconfig = "nvim ~/.dotfiles/home-manager/hosts/LFX001.nix";

    # Utilities
    myip = "curl -s https://api.ipify.org && echo";
    weather = "curl wttr.in";

    # Docker with Colima (if using)
    # colima-start = "colima start --cpu 4 --memory 8";
  };

  # Zsh extra configuration for this machine
  programs.zsh.initExtra = lib.mkAfter ''
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

    # iTerm2 integration (if using iTerm2)
    test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"

    # 1Password CLI (if using)
    # eval "$(op completion zsh)"; compdef _op op

    # Mise (if still using during transition)
    if command -v mise >/dev/null 2>&1; then
      eval "$(mise activate zsh)"
    fi
  '';

  # VS Code settings (if using)
  # programs.vscode = {
  #   enable = true;
  #   userSettings = {
  #     "editor.fontSize" = 14;
  #     "editor.fontFamily" = "PragmataPro Liga";
  #     "editor.fontLigatures" = true;
  #     "terminal.integrated.fontFamily" = "PragmataPro Liga";
  #   };
  # };

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