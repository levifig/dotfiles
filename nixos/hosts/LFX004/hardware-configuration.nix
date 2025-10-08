# Hardware configuration for LFX004
# This file will be generated during NixOS installation
# Run: nixos-generate-config --root /mnt
#
# IMPORTANT: After running nixos-generate-config, merge the generated content
# with this template to preserve BTRFS-specific mount options and subvolume layout

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # This is a BTRFS template - will be replaced by actual hardware scan
  # during NixOS installation. The disk-config.nix handles the declarative
  # partitioning via disko.

  # Kernel modules (will be detected during hardware scan)
  # Typical for Lenovo L14 Gen2:
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];  # Use "kvm-amd" for AMD CPUs
  boot.extraModulePackages = [ ];

  # File system configuration - BTRFS with subvolumes
  # NOTE: These will be automatically configured by disko during installation
  # Keep this as reference for manual verification

  # Root subvolume
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
  };

  # Boot partition (EFI)
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "vfat";
    options = [ "defaults" "umask=0077" ];
  };

  # Home subvolume
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
  };

  # Nix store subvolume
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
  };

  # Persistent state subvolume
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
    neededForBoot = true;
  };

  # Snapshots subvolume
  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@snapshots"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
  };

  # Swap subvolume
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
  };

  # Log files subvolume
  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "btrfs";
    options = [
      "subvol=@log"
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
    neededForBoot = true;
  };

  # Swap file configuration
  # After installation, create swap file with:
  # sudo btrfs filesystem mkswapfile --size 8g /swap/swapfile
  # sudo swapon /swap/swapfile
  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # CPU microcode updates
  # Lenovo L14 Gen2 typically has Intel CPU, but check with: lscpu
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD CPUs (if applicable):
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}