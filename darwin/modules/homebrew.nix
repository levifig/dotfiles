{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Declarative Homebrew Management via nix-homebrew
  # This makes Homebrew packages part of your Nix generations and allows rollback

  homebrew = {
    enable = true;

    # Automatically run brew update/upgrade/cleanup on activation
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall"; # Only remove unused dependencies (safer than "zap")
      # Note: Change to "zap" after reviewing to remove all undeclared packages
    };

    # Homebrew taps
    # Note: Custom taps are now managed via nix-homebrew in flake.nix
    # This ensures they are immutable and part of the flake inputs
    taps = [ ];

    # Homebrew formulas (CLI tools)
    # Note: Cross-platform tools are managed via Nix (see home-manager profiles)
    # macOS CLI tools (mas, duti, trash) are in home-manager/platform/darwin-base.nix
    brews = [
      # macOS utilities not in nixpkgs
      "terminal-notifier"

      # Window management
      "yabai" # Tiling window manager
      "jackielii/tap/skhd-zig" # Hotkey daemon (Zig rewrite)
      "sketchybar" # Custom macOS status bar

      # Development tools
      "xcodes" # Xcode version management

      # Database with service management
      # Using Homebrew for better launchd integration
      "postgresql@18" # Development database (brew services start postgresql@18)

      # Container runtime (CLI tool, not a cask)
      "colima"
    ];

    # Homebrew Casks (GUI applications)
    casks = [
      # Security & Authentication
      "1password"
      "1password-cli"

      # Window Management
      "aerospace" # Current window manager

      # Terminal Emulators
      "iterm2"

      # Browsers (multiple for testing/preferences)
      "arc"
      "brave-browser"
      "firefox@beta"
      "zen"

      # Productivity & Utilities
      "alfred"
      "raycast"
      "bartender"
      "bettertouchtool"
      "cleanshot"
      "contexts"

      # Development Tools

      "github"

      # AI & LLM Tools
      "claude"
      "chatgpt"
      "lm-studio"
      "ollama-app"

      # Cloud & Infrastructure
      "aws-vault-binary"
      "cloudflare-warp"

      # Database & API Tools
      "beekeeper-studio"
      "sequel-ace"

      # Communication
      "discord"
      "slack@beta"
      "zoom"

      # Design & Creative
      "figma"
      "blender"
      "godot"
      "obs"

      # Media & Entertainment
      "iina"
      "vlc"
      "spotify"

      # Virtualization & Container Tools
      "orbstack"
      "utm"
      "vmware-fusion"
      "parallels"

      # File Management & Sync
      "google-drive"
      "dropbox"

      # System Monitoring & Utilities
      "stats"
      "appcleaner"
      "aldente"
      "betterdisplay"
      "karabiner-elements"
      "hammerspoon"
      "sensei"
      "monitorcontrol"

      # Specialized Tools
      "linear-linear"
      "notion"
      "obsidian"
      "todoist-app"
      "typora"

      # Gaming & Benchmarking
      "steam"
      "geekbench"

      # Audio/Music Production
      "ableton-live-lite"
      "reaper"

      # Photography & Video
      "darktable"
      "handbrake"
    ];

    # Mac App Store apps
    # Use `mas search <app name>` to find app IDs
    masApps = {
      # Development
      "Xcode" = 497799835;
      "TestFlight" = 899247664;
      "Developer" = 640199958;

      # Productivity
      "Things" = 904280696;
      "Craft" = 1487937127;
      "Notion Web Clipper" = 1559269364;
      "Obsidian Web Clipper" = 6720708363;

      # Utilities
      "Amphetamine" = 937984704;
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;

      # Creative/Design
      "Affinity Designer 2" = 1616831348;
      "Affinity Photo 2" = 1616822987;
      "Affinity Publisher 2" = 1606941598;
      "Pixelmator Pro" = 1289583905;

      # Apple Pro Apps (commented - install manually if needed)
      "Final Cut Pro" = 424389933;
      "Logic Pro" = 634148309;
      "Motion" = 434290957;
      "Compressor" = 424390742;

      # Media
      "Infuse" = 1136220934;

      # Development/Reading
      "Marked 2" = 890031187;
      "Kindle" = 302584613;
      "Unread" = 1363637349;

      # System Tools
      "WireGuard" = 1451685025;

      # Safari Extensions
      "Keyword Search" = 1558453954;
      "Save to Raindrop.io" = 1549370672;
      "Sink It for Reddit" = 6449873635;
      "Hush" = 1544743900;
    };
  };
}
