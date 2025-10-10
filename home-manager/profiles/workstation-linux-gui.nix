{ config, pkgs, lib, ... }:

{
  # Linux GUI workstation profile
  # Provides Linux equivalents of macOS Homebrew cask applications
  # Designed for desktop/laptop workstations with GUI environments

  imports = [
    ./workstation.nix  # Base workstation setup (includes fonts, terminal configs, ghostty)
  ];

  home.packages = with pkgs; [
    # ============================================
    # Browsers
    # ============================================
    firefox
    brave
    chromium  # Open-source Chrome equivalent
    # arc - Not available on Linux
    # zen-browser - Check if available or use Firefox

    # ============================================
    # Terminal Emulators
    # ============================================
    alacritty
    # ghostty - Installed via modules/terminal/ghostty.nix (from nixpkgs)

    # ============================================
    # Development Tools
    # ============================================
    vscode
    zed-editor
    sublime4
    # cursor - Not available in nixpkgs, manual install required
    # github-desktop - Limited Linux support

    # ============================================
    # AI & LLM Tools
    # ============================================
    # claude - Not available, use browser
    # chatgpt - Not available, use browser
    # lm-studio - Not available on Linux
    # ollama - Available but typically installed separately

    # ============================================
    # Communication
    # ============================================
    discord
    slack
    telegram-desktop
    zoom-us
    # signal-desktop  # If needed

    # ============================================
    # Cloud & Infrastructure
    # ============================================
    tailscale

    # ============================================
    # Database & API Tools
    # ============================================
    dbeaver-bin
    # beekeeper-studio  # Check if available in nixpkgs
    sqlitebrowser  # Equivalent to db-browser-for-sqlite

    # ============================================
    # Design & Creative
    # ============================================
    # figma-linux  # Community package, may need unfree
    blender
    godot_4
    obs-studio
    krita  # Digital painting
    inkscape  # Vector graphics
    gimp  # Photo editing

    # ============================================
    # Media & Entertainment
    # ============================================
    mpv  # Lightweight video player (alternative to iina)
    vlc
    spotify
    # handbrake  # Video transcoder

    # ============================================
    # Productivity & Note Taking
    # ============================================
    obsidian
    # notion-app-enhanced  # Check if available
    # todoist  # May need electron version or web app
    typora  # Markdown editor (requires unfree)
    # logseq  # Alternative to Obsidian
    marktext  # Open-source Markdown editor

    # ============================================
    # System Utilities
    # ============================================
    # Note: 1Password packages are in profiles/workstation.nix for cross-platform consistency
    flameshot  # Screenshot tool (alternative to cleanshot)
    # copyq  # Clipboard manager
    # albert  # Launcher (alternative to alfred/raycast)
    # ulauncher  # Another launcher option

    # ============================================
    # File Management & Sync
    # ============================================
    # insync  # Google Drive client (proprietary)
    rclone  # CLI Google Drive sync (already in config)
    # dropbox  # May need manual install
    # syncthing  # P2P file sync

    # ============================================
    # Virtualization & Containers
    # ============================================
    # virt-manager  # KVM/QEMU manager
    virtualbox  # Cross-platform VM
    # docker-desktop  # Use docker + lazydocker instead

    # ============================================
    # Audio/Music Production
    # ============================================
    # reaper  # DAW (proprietary)
    # ardour  # Open-source DAW
    audacity  # Audio editor

    # ============================================
    # Photography & Video
    # ============================================
    darktable  # Photo workflow (RAW processor)
    # rawtherapee  # Alternative RAW processor
    # kdenlive  # Video editor

    # ============================================
    # Gaming
    # ============================================
    # steam  # Usually installed system-wide
    # lutris  # Game manager

    # ============================================
    # Linux Desktop Integration
    # ============================================
    # gnome-tweaks  # For GNOME
    # kde-config-gtk-style  # For KDE
    pavucontrol  # PulseAudio volume control
    # networkmanagerapplet  # Already in LFX004.nix

    # ============================================
    # Additional Linux Tools
    # ============================================
    # thunar  # File manager (XFCE)
    # nautilus  # File manager (GNOME)
    # dolphin  # File manager (KDE)
    gparted  # Partition editor
    # timeshift  # System snapshots
  ];

  # GUI-specific environment variables
  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    # Enable Wayland support for various apps
    MOZ_ENABLE_WAYLAND = "1";  # Firefox
    QT_QPA_PLATFORM = "wayland";  # Qt apps
    SDL_VIDEODRIVER = "wayland";  # SDL apps
    _JAVA_AWT_WM_NONREPARENTING = "1";  # Java apps in tiling WMs
  };

  # XDG MIME type associations for GUI apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      "application/pdf" = "org.gnome.Evince.desktop";

      "image/png" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";

      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";

      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
    };
  };

  # Enable services for GUI integration
  services = {
    # Flatpak for additional GUI applications not in nixpkgs
    # Note: This is enabled at system level, not home-manager
    # flatpak.enable = true;
  };

  # Note: Many proprietary apps require allowUnfree = true in nixpkgs config
  # Add to ~/.config/nixpkgs/config.nix or system configuration:
  # { allowUnfree = true; }
}
