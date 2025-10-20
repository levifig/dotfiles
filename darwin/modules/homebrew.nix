{
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
      cleanup = "uninstall";
    };

    # Homebrew taps
    # Note: Custom taps are now managed via nix-homebrew in flake.nix
    # This ensures they are immutable and part of the flake inputs
    # Listed here to prevent removal during cleanup
    taps = [
      "jackielii/tap"
      "dagger/tap"
    ];

    # Homebrew formulas (CLI tools)
    # Note: Cross-platform tools are managed via Nix (see home-manager profiles)
    # macOS CLI tools (mas, duti, trash) are in home-manager/platform/darwin-base.nix
    brews = [
      "terminal-notifier"
      "mas"

      # Window management
      # "yabai"
      # "jackielii/tap/skhd-zig"
      # "sketchybar"

      # Development tools
      # "xcodes"

      # Database with service management
      # Using Homebrew for better launchd integration
      "postgresql@18" # Development database (brew services start postgresql@18)

      # Container runtime (CLI tool, not a cask)
      "colima"
    ];

    # Homebrew Casks (GUI applications)
    casks = [
      "1password"
      "1password-cli"
      # "ableton-live-lite"
      # "aerospace"
      # "alacritty"
      "aldente"
      # "alfred"
      "altserver"
      "appcleaner"
      "applite"
      "arc"
      "aws-vault-binary"
      # "bambu-studio"
      "bartender"
      # "beekeeper-studio"
      "betterdisplay"
      "bettermouse"
      "bettertouchtool"
      "betterzip"
      "blender"
      # "block-goose"
      "brave-browser"
      "calibre"
      "chatgpt"
      # "cinebench"
      "claude"
      "cleanshot"
      "clop"
      "cloudflare-warp"
      "container-use"
      "contexts"
      "cursor"
      "daisydisk"
      "darktable"
      "db-browser-for-sqlite"
      # "dbeaver-community"
      "discord"
      "drawio"
      "dropbox"
      "element"
      "espanso"
      # "fantastical"
      "fastmail"
      "figma"
      "firefox@beta"
      "firefox@developer-edition"
      # "foldingtext"
      # "font-poppins"
      "geekbench"
      "geekbench-ai"
      "getoutline"
      "ghostty"
      "github"
      "github-copilot-for-xcode"
      # "godot"
      "google-drive"
      "hammerspoon"
      "handbrake-app"
      "heaven"
      "hex-fiend"
      "hyperbackupexplorer"
      "iina"
      "imageoptim"
      "imazing"
      "iterm2"
      "kaleidoscope"
      # "karabiner-elements"
      "keeper-password-manager"
      "keymapp"
      "kiro"
      "latest"
      # "librewolf"
      "linear-linear"
      "lm-studio"
      "logos"
      # "luxmark"
      # "macfuse"
      "maciasl"
      "macwhisper"
      # "mongodb-compass"
      "monitorcontrol"
      # "monodraw"
      # "mos"
      "mqtt-explorer"
      "multiviewer"
      "native-access"
      "ndi-tools"
      "nordvpn"
      # "notesollama"
      # "notion"
      "obs"
      "obsidian"
      # "ollama-app"
      "openaudible"
      "orbstack"
      "pacifist"
      # "parallels"
      "permute"
      "plexamp"
      "powerphotos"
      # "propresenter"
      "qmk-toolbox"
      "rapidapi"
      "raspberry-pi-imager"
      "raycast"
      # "reaper"
      "rectangle-pro"
      # "reflex-app"
      "remote-desktop-manager"
      # "renamer"
      "rocket"
      "rubymine"
      "safari-technology-preview"
      "screens"
      "sensei"
      "sequel-ace"
      # "setapp"
      # "sf-symbols"
      # "sigmaos"
      "slack@beta"
      "sonos"
      # "spitfire-audio"
      "spotify"
      "stats"
      "steam"
      # "studio-3t-community"
      "sublime-text"
      "superduper"
      "tailscale-app"
      "telegram"
      "temurin"
      "textual"
      "thingsmacsandboxhelper"
      "timemachineeditor"
      "todoist-app"
      # "tor-browser"
      "typora"
      "ubersicht"
      # "ungoogled-chromium"
      "utm"
      "vagrant"
      # "vanilla"
      "via"
      "vial"
      "virtualbuddy"
      "visual-studio-code"
      "vivid-app"
      "vlc"
      "vmware-fusion"
      "wacom-tablet"
      "wezterm"
      "whatsapp"
      "whisky"
      "wifiman"
      "winbox"
      # "xcodes-app"
      "xnapper"
      "yubico-authenticator"
      "zed"
      "zen"
      # "zoom"
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
