# Common NixOS configuration shared across all NixOS machines

{ config, pkgs, lib, ... }:

{
  # Nix daemon settings
  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Optimise store
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # Common system packages
  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    vim
    neovim
    git
    curl
    wget
    htop
    btop
    tmux

    # File utilities
    ripgrep
    fd
    fzf
    tree
    bat
    eza

    # Network tools
    nmap
    traceroute
    dig
    whois

    # Archives
    unzip
    zip
    p7zip

    # System info
    lshw
    pciutils
    usbutils
  ];

  # Common programs
  programs = {
    # Git
    git.enable = true;

    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Common services
  services = {
    # Automatic updates
    #    automatic-timezoned.enable = true;  # Auto timezone
  };

  # Security
  security = {
    # Sudo configuration
    sudo = {
      enable = true;
      extraRules = [
        {
          users = [ "levifig" ];
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl restart *";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl stop *";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl start *";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}