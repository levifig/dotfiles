{ config, pkgs, lib, ... }:

{
  # Workstation Headless profile - Full development environment without GUI
  # Builds on server.nix, adds all CLI development tools
  # Perfect for remote workstations, SSH sessions, or headless systems

  imports = [
    ./server.nix  # Inherit all server tools
    ./development.nix  # Development tools and language runtimes
    ../modules/shell/zsh.nix
    ../modules/shell/atuin.nix
    ../modules/editors/nvim.nix
    ../modules/terminal/tmux.nix
    ../modules/shell/starship.nix
  ];

  home.packages = with pkgs; [
    # Upgrade to better alternatives
    # Note: neovim is configured via modules/editors/nvim.nix
    bat         # Better cat
    eza         # Better ls
    fd          # Better find
    zoxide      # Smart cd

    # Shell enhancements
    fzf
    starship
    # Note: atuin is configured via modules/shell/atuin.nix
    # Note: direnv is provided by development.nix

    # Development tools - Version management
    # Note: Language runtimes (node, ruby, python, go) are provided by development.nix
    # Only include tools not in development.nix here
    bun
    uv

    # Note: Build tools and language toolchains are provided by development.nix

    # Container tools (basic docker, k8s/cloud tools from platform.nix)
    docker-client
    docker-compose
    lazydocker

    # Note: Kubernetes, IaC, and Cloud tools are provided by platform.nix profile
    # Note: Database tools are provided by development.nix profile
    # Note: Git tools (gh, delta, etc.) are provided by development.nix profile

    # Utilities specific to workstation-headless
    jump
    just
    tokei
    hyperfine

    # Cloud storage and sync
    rclone
    icloudpd

    # Media utilities
    mediainfo
    exiftool

    # Container runtime (alternative to Docker Desktop)
    colima

    # Fun utilities
    cowsay
    fortune
  ];

  # Note: Shell aliases are centralized in modules/shell/aliases.nix

  # Development environment variables
  home.sessionVariables = {
    EDITOR = lib.mkForce "nvim";  # Override server.nix vim setting
    VISUAL = lib.mkForce "nvim";

    # Note: Language-specific XDG paths (GOPATH, CARGO_HOME, etc.) are set in modules/core/xdg.nix

    # Cloud
    AWS_PAGER = "";  # Disable AWS CLI pager
  };

  # Note: direnv and language-specific programs are configured in development.nix
}
