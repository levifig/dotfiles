{ config, pkgs, lib, ... }:

{
  # Homebrew integration for macOS
  # This manages Homebrew packages declaratively through Nix

  # Note: This requires nix-darwin for full functionality
  # For now, we'll manage the Brewfile

  # Create and manage Brewfile
  home.file.".Brewfile" = {
    text = ''
      # Taps
      tap "homebrew/bundle"
      tap "homebrew/services"
      tap "hashicorp/tap"

      # GUI Applications (Casks)
      # These stay in Homebrew as they're not well-supported in Nix

      ## Browsers
      cask "firefox"
      cask "google-chrome"
      cask "arc"

      ## Development
      cask "visual-studio-code"
      cask "docker"
      cask "orbstack"  # Better Docker Desktop alternative
      cask "tableplus"
      cask "postman"
      cask "insomnia"

      ## Communication
      cask "slack"
      cask "discord"
      cask "zoom"
      cask "microsoft-teams"

      ## Productivity
      cask "notion"
      cask "obsidian"
      cask "raycast"
      cask "1password"
      cask "1password-cli"

      ## Utilities
      cask "rectangle"  # Window management
      cask "stats"      # System monitor
      cask "iina"       # Video player
      cask "the-unarchiver"
      cask "appcleaner"

      ## Design
      cask "figma"

      ## Cloud Storage
      cask "dropbox"
      cask "google-drive"

      # macOS-specific CLI tools
      # These work better from Homebrew on macOS
      brew "mas"        # Mac App Store CLI
      brew "trash"      # Move to trash instead of rm
      brew "duti"       # Set default applications

      # Services that need Homebrew's service management
      brew "postgresql@15", restart_service: true
      brew "redis", restart_service: true
      brew "mysql", restart_service: true

      # Mac App Store apps (requires mas)
      mas "Things", id: 904280696
      mas "Xcode", id: 497799835
      mas "Amphetamine", id: 937984704
      mas "Hidden Bar", id: 1452453066
    '';
  };

  # Shell aliases for Homebrew management
  home.shellAliases = lib.mkIf pkgs.stdenv.isDarwin {
    # Brewfile management
    brewdump = "brew bundle dump --file=~/.Brewfile --force";
    brewinstall = "brew bundle --file=~/.Brewfile";
    brewcleanup = "brew bundle cleanup --file=~/.Brewfile";

    # Update everything
    brewup = "brew update && brew upgrade && brew cleanup";
    brewhealth = "brew doctor && brew missing";

    # Services
    brewservices = "brew services list";

    # Search
    casks = "brew search --casks";
  };

  # Environment variables for Homebrew
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_AUTO_UPDATE = "1";  # We'll update manually
    HOMEBREW_BUNDLE_FILE = "~/.Brewfile";
  };

  # Script to install Homebrew if not present and run bundle
  home.file.".local/bin/setup-homebrew" = lib.mkIf pkgs.stdenv.isDarwin {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      echo "🍺 Setting up Homebrew..."

      # Install Homebrew if not present
      if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
          eval "$(/usr/local/bin/brew shellenv)"
        fi
      fi

      # Update Homebrew
      echo "Updating Homebrew..."
      brew update

      # Install from Brewfile
      if [[ -f ~/.Brewfile ]]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file=~/.Brewfile

        echo "Cleaning up old packages..."
        brew bundle cleanup --file=~/.Brewfile --force

        echo "✅ Homebrew setup complete!"
      else
        echo "⚠️  No Brewfile found at ~/.Brewfile"
      fi
    '';
  };

  # Create a comparison script to show what's managed where
  home.file.".local/bin/package-report" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      echo "📦 Package Management Report"
      echo "============================"
      echo ""

      if command -v brew >/dev/null 2>&1; then
        echo "🍺 Homebrew Packages:"
        echo "--------------------"
        echo "Formulas: $(brew list --formula | wc -l)"
        echo "Casks: $(brew list --cask | wc -l)"
        echo ""
      fi

      if command -v nix >/dev/null 2>&1; then
        echo "❄️  Nix Packages:"
        echo "---------------"
        echo "User packages: $(nix-env -q | wc -l)"
        if [[ -f ~/.nix-profile/manifest.json ]]; then
          echo "Profile packages: $(cat ~/.nix-profile/manifest.json | grep -o '"pname"' | wc -l)"
        fi
        echo ""
      fi

      echo "💡 Recommendation:"
      echo "-----------------"
      echo "GUI apps     → Homebrew (casks)"
      echo "CLI tools    → Nix"
      echo "Services     → Homebrew (for launchd integration)"
      echo "Dev tools    → Nix (reproducible environments)"
    '';
  };
}