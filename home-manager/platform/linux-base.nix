{ config, pkgs, lib, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    xclip
    xsel
    wmctrl
    xdotool

    # System monitoring
    lm_sensors
    sysstat
    iotop

    # Linux-specific development tools
    strace
    ltrace
    valgrind

    # File systems
    ntfs3g
    exfat
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # Use xdg-open on Linux
    BROWSER = "xdg-open";

    # Enable colored GCC warnings and errors
    GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";

    # Java GUI fix for tiling window managers
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Linux-specific shell aliases
  home.shellAliases = {
    # System management
    systemctl = "systemctl --user";
    journalctl = "journalctl --user";

    # Clipboard
    clip = "xclip -selection clipboard";
    paste = "xclip -selection clipboard -o";

    # Package management (will vary by distro)
    update = "sudo apt update && sudo apt upgrade";  # Debian/Ubuntu
    # update = "sudo dnf update";  # Fedora
    # update = "sudo pacman -Syu";  # Arch

    # IP addresses
    localip = "hostname -I | awk '{print $1}'";
    ips = "ip -4 addr | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'";

    # Open file manager
    open = "xdg-open";
    finder = "xdg-open .";

    # Process management
    psmem = "ps auxf | sort -nr -k 4 | head -10";
    pscpu = "ps auxf | sort -nr -k 3 | head -10";
  };

  # systemd user services
  systemd.user.startServices = "sd-switch";

  # XDG settings
  xdg = {
    enable = true;

    # User directories
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };

    # Default applications
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = ["firefox.desktop"];
        "text/xml" = ["code.desktop"];
        "text/plain" = ["nvim.desktop"];
        "application/pdf" = ["org.gnome.Evince.desktop"];
        "image/png" = ["org.gnome.eog.desktop"];
        "image/jpeg" = ["org.gnome.eog.desktop"];
        "image/gif" = ["org.gnome.eog.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "audio/mpeg" = ["mpv.desktop"];
      };
    };
  };

  # Programs with Linux-specific configuration
  programs.zsh.initExtra = lib.mkAfter ''
    # Linux specific ZSH configuration

    # Add snap to PATH if it exists
    if [[ -d /snap/bin ]]; then
      export PATH="/snap/bin:$PATH"
    fi

    # Add flatpak exports to PATH
    if [[ -d /var/lib/flatpak/exports/bin ]]; then
      export PATH="/var/lib/flatpak/exports/bin:$PATH"
    fi
    if [[ -d ~/.local/share/flatpak/exports/bin ]]; then
      export PATH="~/.local/share/flatpak/exports/bin:$PATH"
    fi

    # SSH agent
    if [ -z "$SSH_AUTH_SOCK" ]; then
      eval $(ssh-agent -s)
    fi
  '';

  # Font configuration for Linux
  fonts.fontconfig.enable = true;

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };
  };

  # Qt theme configuration
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
  };
}