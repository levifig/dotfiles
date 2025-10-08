# NixOS configuration for LFX004
# This file will be used when LFX004 is running NixOS

{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    # Include common NixOS modules
    ../../modules/common.nix
  ];

  # System-wide configuration
  system.stateVersion = "24.05"; # Did you read the comment?

  # Hostname
  networking.hostName = "LFX004";

  # Time zone
  time.timeZone = "America/Los_Angeles";  # Adjust to your timezone

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Users
  users.users.levifig = {
    isNormalUser = true;
    description = "Levi Figueira";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "postgres" ];
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    home-manager
  ];

  # Enable programs
  programs.zsh.enable = true;

  # Services
  services = {
    # X11/Desktop
    xserver = {
      enable = true;

      # Keyboard layout
      xkb.layout = "us";
      xkb.variant = "";
    };

    # Display Manager
    displayManager.gdm.enable = true;  # Or lightdm

    # Desktop Manager
    desktopManager.gnome.enable = true;  # Or none for WM-only
    # windowManager.i3.enable = true;  # Uncomment if using i3

    # Sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # SSH
    openssh.enable = true;

    # Database
    postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
      '';
      settings = {
        # Development-friendly settings
        max_connections = 100;
        shared_buffers = "128MB";
      };
    };

    # Power management
    tlp.enable = true;
    power-profiles-daemon.enable = false;  # Conflicts with TLP
  };

  # Virtualisation
  virtualisation = {
    docker.enable = true;
  };

  # Hardware
  hardware = {
    # Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Enable graphics
    graphics.enable = true;
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.meslo-lg
  ];
}