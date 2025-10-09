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
    taps = [];

    # Homebrew formulas (CLI tools)
    # Note: Cross-platform tools are managed via Nix (see home-manager profiles)
    # macOS CLI tools (mas, duti, trash) are in home-manager/platform/darwin-base.nix
    brews = [
      # macOS utilities not in nixpkgs
      "terminal-notifier"

      # Window management
      "yabai" # Tiling window manager
      "skhd" # Hotkey daemon
      "sketchybar" # Custom macOS status bar

      # Media processing
      "ffmpeg" # Video/audio processing with all codecs

      # Development tools
      "xcodes" # Xcode version management

      # AI/LLM
      "llama.cpp" # Local LLM inference

      # Database with service management
      # Using Homebrew for better launchd integration
      "postgresql@18" # Development database (brew services start postgresql@18)

      # Container runtime (CLI tool, not a cask)
      "colima"
    ];

    # Homebrew Casks (GUI applications)
    casks = [
      # Note: 1Password packages are managed via Nix in home-manager/profiles/workstation.nix

      # Window Management
      "aerospace" # Current window manager

      # Terminal Emulators
      # alacritty - Now managed via Nix (home-manager/modules/terminal/alacritty.nix)
      # ghostty - Now managed via Nix (home-manager/modules/terminal/ghostty.nix)
      "iterm2" # Backup terminal

      # Browsers (multiple for testing/preferences)
      "arc"
      "brave-browser"
      "firefox@beta"
      "zen" # Renamed from zen-browser

      # Productivity & Utilities
      "alfred"
      "raycast"
      "bartender"
      "bettertouchtool"
      "cleanshot"
      "contexts"

      # Development Tools
      # docker-desktop - Removed (use colima + docker CLI or orbstack instead)
      "visual-studio-code"
      "zed"
      "cursor"
      "github" # GitHub Desktop
      "sublime-text" # Quick editor

      # AI & LLM Tools
      "claude" # Claude Desktop
      "chatgpt" # ChatGPT Desktop
      "lm-studio" # Local LLM management
      "ollama-app" # Renamed from ollama

      # Cloud & Infrastructure
      "aws-vault-binary" # Renamed from aws-vault
      # tailscale - Using Nix version (cross-platform)
      "cloudflare-warp"

      # Database & API Tools
      "beekeeper-studio"
      "db-browser-for-sqlite"
      "sequel-ace"

      # Communication
      "discord"
      "slack@beta"
      # telegram - Using MAS version instead
      "zoom"

      # Design & Creative
      "figma"
      "blender" # 3D modeling - install when needed
      "godot" # Game engine - install when needed
      "obs"

      # Media & Entertainment
      "iina" # Video player
      # spotify - Using Nix version (cross-platform)
      # handbrake - Using Nix version (cross-platform)
      "vlc"

      # Virtualization & Container Tools
      "orbstack" # Docker/Linux VMs
      "utm" # Virtual machines
      "vagrant" # VM orchestration
      "vmware-fusion" # Commercial - install manually if needed
      "parallels" # Commercial - install manually if needed

      # File Management & Sync
      "google-drive"
      "dropbox"

      # System Monitoring & Utilities
      "stats"
      "appcleaner" # Clean app uninstalls
      "aldente" # Battery management
      "betterdisplay" # Display management
      "karabiner-elements" # Keyboard customization
      "hammerspoon" # Automation toolkit
      "sensei"
      "monitorcontrol"

      # Specialized Tools
      "linear-linear"
      "notion"
      "obsidian"
      "todoist-app" # Renamed from todoist
      "typora" # Markdown editor

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

      # Note: Telegram managed via Nix (telegram-desktop in workstation.nix)

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
