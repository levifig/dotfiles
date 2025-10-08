{ config, pkgs, lib, ... }:

{
  # Declarative Homebrew Management via nix-homebrew
  # This makes Homebrew packages part of your Nix generations and allows rollback

  homebrew = {
    enable = true;

    # Automatically run brew update/upgrade/cleanup on activation
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";  # Uninstall packages not declared here
    };

    # Homebrew taps
    taps = [
      "dagger/tap"
      "dracula/install"
      "felixkratz/formulae"
      "hashicorp/tap"
      "jackielii/tap"
      "koekeishiya/formulae"
      "nikitabobko/tap"
      "sst/tap"
    ];

    # Homebrew formulas (CLI tools)
    # Note: Prefer Nix packages when available, use Homebrew for macOS-specific tools
    brews = [
      # Platform/Infrastructure tools not in Nix or better via Homebrew
      "argocd"
      "helm"
      "k9s"
      "kubernetes-cli"
      "krew"
      "lazydocker"
      "talosctl"
      "velero"

      # macOS-specific tools
      "mas"  # Mac App Store CLI
      "terminal-notifier"

      # Development tools (if not in Nix)
      # Commented out - prefer Nix versions when available
      # "awscli"
      # "terraform"
      # "go"
    ];

    # Homebrew Casks (GUI applications)
    casks = [
      # Security & Authentication
      "1password"
      "1password-cli"

      # Window Management
      "aerospace"  # Current window manager
      # "hammerspoon"  # Alternative window manager
      # "rectangle-pro"  # Alternative window manager

      # Terminal & Development
      "alacritty"
      "ghostty"
      # "iterm2"
      # "wezterm@nightly"

      # Browsers
      "arc"
      "brave-browser"
      # "firefox@developer-edition"
      # "librewolf"
      # "zen-browser"

      # Productivity & Utilities
      "alfred"
      "raycast"
      "bartender"
      "bettertouchtool"
      "cleanshot"
      "contexts"

      # Development Tools
      "docker"
      "visual-studio-code"
      "zed"
      # "cursor"

      # Cloud & Infrastructure
      "aws-vault"
      "tailscale"
      "cloudflare-warp"

      # Database & API Tools
      "beekeeper-studio"
      # "db-browser-for-sqlite"
      # "sequel-ace"

      # Communication
      "discord"
      "slack@beta"
      "telegram"
      # "whatsapp"
      # "zoom"

      # Design & Creative
      "figma"
      # "blender"
      # "obs"

      # Media & Entertainment
      # "iina"
      # "spotify"
      # "vlc"

      # Virtualization & Testing
      "utm"
      # "vagrant"
      # "vmware-fusion"

      # File Management & Sync
      "google-drive"
      # "dropbox"

      # System Monitoring
      "stats"
      # "sensei"
      # "monitorcontrol"

      # Specialized Tools
      "linear-linear"
      "notion"
      "obsidian"
      # "craft"  # May prefer Mac App Store version

      # Gaming & Benchmarking
      # "steam"
      # "geekbench"

      # Audio/Music Production
      # "ableton-live-lite"
      # "logic-pro"  # Mac App Store
      # "reaper"

      # Photography & Video
      # "darktable"
      # "davinci-resolve"  # Mac App Store
      # "final-cut-pro"  # Mac App Store
      # "handbrake"
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
      # "Final Cut Pro" = 424389933;
      # "Logic Pro" = 634148309;
      # "Motion" = 434290957;
      # "Compressor" = 424390742;

      # Communication
      "Telegram" = 747648890;

      # Media
      "Infuse" = 1136220934;

      # Development/Reading
      "Marked 2" = 890031187;
      "Kindle" = 302584613;

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
