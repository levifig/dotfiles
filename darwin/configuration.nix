{ config, pkgs, lib, ... }:

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
  nix = {
    package = pkgs.nix;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@admin" "@staff" userName ];

      # Build optimizations
      max-jobs = "auto";
      cores = 0;  # Use all available cores
    };

    # Store optimisation
    optimise.automatic = true;

    # Garbage collection
    gc = {
      automatic = true;
      interval = { Weekday = 7; };  # Weekly
      options = "--delete-older-than 30d";
    };
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
        tilesize = 48;
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
        AppleShowScrollBars = "Automatic";
        AppleInterfaceStyle = "Dark";
        "com.apple.swipescrolldirection" = false;  # Disable natural scrolling
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true;  # Tap to click
        TrackpadRightClick = true;
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
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
    bash.enable = true;
  };

  # Users
  users.users.${userName} = {
    name = userName;
    home = homeDir;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Used for backwards compatibility
  system.configurationRevision = null;
}
