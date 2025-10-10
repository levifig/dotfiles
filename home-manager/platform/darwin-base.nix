{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../modules/darwin/sketchybar.nix
    ../modules/darwin/ubersicht.nix
    ../modules/darwin/aerospace.nix
    ../modules/darwin/karabiner.nix
    ../modules/darwin/hammerspoon.nix
    ../modules/darwin/yabai.nix
    ../modules/darwin/wezterm.nix
  ];

  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS-friendly tools
    mas # Mac App Store CLI
    duti # Set default applications
    trash-cli # Move files to trash instead of rm
  ];

  # macOS-specific environment variables
  home.sessionVariables = {
    # Use macOS open command
    BROWSER = "open";

    # macOS specific paths
    XML_CATALOG_FILES = "/usr/local/etc/xml/catalog";

    # Homebrew prefix (for compatibility with existing scripts)
    BREW_PREFIX = "/opt/homebrew"; # Apple Silicon default
    RUSTUP_PREFIX = "/opt/homebrew/opt/rustup";
  };

  # macOS-specific shell aliases
  home.shellAliases = {
    # macOS specific
    showfiles = "defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder";

    # Quick Look
    ql = "qlmanage -p";

    # Clipboard
    clip = "pbcopy";
    paste = "pbpaste";

    # Flush DNS
    flushdns = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";

    # Clean up LaunchServices
    lscleanup = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder";

    # Empty trash
    emptytrash = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl";

    # Update everything
    update = "brew update && brew upgrade && brew cleanup";

    # IP addresses
    localip = "ipconfig getifaddr en0";
    ips = "ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'";
  };

  # Programs with macOS-specific configuration
  programs.zsh.initContent = lib.mkAfter ''
    # macOS specific ZSH configuration

    # Add Homebrew to PATH if it exists
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  '';

  # Git configuration for macOS
  programs.git.extraConfig = {
    credential.helper = "osxkeychain";
  };

  # macOS-specific file associations
  xdg.mimeApps = lib.mkIf pkgs.stdenv.isDarwin {
    defaultApplications = {
      "text/html" = [
        "org.mozilla.firefox.desktop"
        "com.apple.Safari.desktop"
      ];
      "text/xml" = [ "code.desktop" ];
      "application/pdf" = [ "com.apple.Preview.desktop" ];
      "image/png" = [ "com.apple.Preview.desktop" ];
      "image/jpeg" = [ "com.apple.Preview.desktop" ];
      "image/gif" = [ "com.apple.Preview.desktop" ];
    };
  };

  # Note: For system-level macOS configuration (like defaults write commands),
  # we'll use nix-darwin in a separate configuration
}
