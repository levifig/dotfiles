{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Workstation profile - Full GUI workstation setup
  # Builds on workstation-headless.nix, adds GUI applications
  # Perfect for local development machines

  imports = [
    ./workstation-headless.nix # Inherit all headless workstation tools
    ../modules/terminal/alacritty.nix
    ../modules/terminal/ghostty.nix
    ../modules/fonts/fonts.nix # Private fonts for GUI applications
    # Add other GUI-specific modules here
  ];

  home.packages = with pkgs; [
    # Security & Authentication
    _1password-gui # 1Password GUI application
    _1password-cli # 1Password CLI

    # Development Tools
    vscode # Visual Studio Code
    zed-editor # Zed editor
    code-cursor # Cursor editor

    # Communication
    telegram-desktop # Cross-platform Telegram client

    # Cloud & Infrastructure
    tailscale # VPN mesh network

    # Media & Entertainment
    spotify # Music streaming
    handbrake # Video transcoding

    # Database & API Tools
    sqlitebrowser # SQLite database browser
  ];

  # GUI-specific environment variables
  home.sessionVariables = {
    # Add GUI-specific vars here if needed
  };

  # Note: Most GUI applications on macOS are better managed through
  # nix-darwin's homebrew module or direct nix-darwin packages.
  # See darwin/configuration.nix for GUI app management.
}
