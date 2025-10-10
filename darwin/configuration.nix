{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Single source of truth for username
  userName = "levifig";
  homeDir = "/Users/${userName}";
in
{
  # Nix-Darwin configuration for macOS
  # This replaces Homebrew for system-level package management

  imports = [
    ./modules/homebrew.nix
    ./modules/dock.nix
  ];

  # System packages (formulae equivalent)
  environment.systemPackages = with pkgs; [
    # Core utilities (some of these may already be in home-manager)
    vim
    git
    curl
    wget
  ];

  # Homebrew configuration moved to ./modules/homebrew.nix

  # Nix settings
  # Note: Using Determinate Nix installer - disable nix-darwin's Nix management
  nix = {
    # Disable nix-darwin's Nix daemon management (Determinate manages it)
    enable = false;

    # Note: nix.settings won't work with enable = false
    # Nix settings are managed by Determinate installer
  };

  # macOS system settings
  system = {
    # Primary user for system defaults
    primaryUser = userName;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 60;
        minimize-to-application = true;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      # NSGlobal domain settings
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 12;
        KeyRepeat = 0;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Tap to click
        TrackpadRightClick = true;
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
    };

    # System state version
    stateVersion = 4;
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      # Add fonts here if managing via Nix
      # (ia-writer-duospace)
      # (pragmatapro)  # If available
    ];
  };

  # LaunchD environment variables (for GUI apps)
  launchd.user.envVariables = {
    PATH = config.environment.systemPath + ":${homeDir}/.nix-profile/bin:${homeDir}/.local/bin";
  };

  # Services
  services = {
    # nix-daemon is now managed automatically by nix-darwin when nix.enable = true

    # Sketchybar (if using)
    # sketchybar.enable = true;

    # Yabai (if using)
    # yabai.enable = true;
  };

  # Programs
  programs = {
    zsh.enable = true;
  };

  # Users
  users.users.${userName} = {
    name = userName;
    home = homeDir;
  };

  # Note: nixpkgs.config (including allowUnfree) is configured in flake.nix
  # via specialArgs to support useGlobalPkgs with home-manager

  # Used for backwards compatibility
  system.configurationRevision = null;
}
