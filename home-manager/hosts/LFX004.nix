{ config, pkgs, lib, ... }:

{
  # Machine-specific configuration for LFX004 (Linux laptop - NixOS)
  home.username = "levifig";
  home.homeDirectory = "/home/levifig";

  # Include platform defaults
  imports = [
    ../platform/linux-base.nix
    ../profiles/workstation-headless.nix  # Includes: server.nix, development.nix, zsh, nvim, tmux, starship
    ../profiles/workstation-linux-gui.nix  # GUI applications (Linux equivalents of macOS casks)
    ../profiles/cli-tools.nix              # Language package manager tools
  ];

  # Linux laptop specific packages
  home.packages = with pkgs; [
    # Linux-specific tools
    xclip
    xsel

    # System utilities
    acpi  # Battery info
    brightnessctl  # Brightness control
    playerctl  # Media player control

    # Networking
    networkmanager
    networkmanagerapplet

    # Power management
    powertop
    tlp

    # Display/Graphics
    arandr
    autorandr  # Auto display configuration

    # Development tools
    gh
    lazydocker

    # Additional utilities
    speedtest-cli
    yt-dlp  # Modern youtube-dl replacement
    tldr
    tree

    # File managers
    ranger
    nnn
  ];

  # Git configuration for this machine
  programs.git = {
    # Email uses default from core/git.nix (me@levifig.com)

    # Signing configuration
    signing = {
      key = "~/.ssh/keys/levifig-ed25519.pub";
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
    };
  };

  # Machine-specific environment variables
  home.sessionVariables = {
    # Development paths
    DEVELOPMENT = "$HOME/Development";
    PROJECTS = "$HOME/Development/Projects";

    # Custom paths
    DOTFILES = "$HOME/.dotfiles";

    # Linux-specific
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";  # Qt Wayland support
  };

  # Machine-specific shell aliases
  home.shellAliases = {
    # Quick navigation
    dev = "cd ~/Development";
    proj = "cd ~/Development/Projects";
    dots = "cd ~/.dotfiles";
    conf = "cd ~/.config";

    # System specific (override linux-base.nix default)
    update = lib.mkForce "sudo nixos-rebuild switch --flake ~/.dotfiles";  # NixOS
    hm-update = "home-manager switch --flake ~/.dotfiles#levifig@LFX004";

    # Quick edits
    zshconfig = "nvim ~/.config/zsh/.zshrc";
    nixconfig = "nvim ~/.dotfiles/home-manager/hosts/LFX004.nix";
    nixos-config = "nvim ~/.dotfiles/nixos/hosts/LFX004/configuration.nix";

    # Utilities
    myip = "curl -s https://api.ipify.org && echo";
    weather = "curl wttr.in";

    # Battery info
    battery = "acpi -b";

    # Display management
    displays = "xrandr --listmonitors";
  };

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

    # NixOS-specific
    if [[ -f /etc/NIXOS ]]; then
      # We're on NixOS
      alias rebuild="sudo nixos-rebuild switch --flake ~/.dotfiles"
      alias rebuild-test="sudo nixos-rebuild test --flake ~/.dotfiles"
      alias rebuild-boot="sudo nixos-rebuild boot --flake ~/.dotfiles"
    fi
  '';

  # Starship prompt customization for this machine
  programs.starship.settings = {
    # Add machine-specific prompt elements
    custom.machine = {
      command = "echo 💻";
      when = "true";
      format = "[$output](bold green) ";
    };
  };

  # systemd user services for Linux
  systemd.user.services = {
    # Example: Auto-mount network drives, sync services, etc.
  };

  # Home Manager release version
  home.stateVersion = "23.11";
}