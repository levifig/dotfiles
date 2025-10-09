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

  # File system configuration is handled by disko (see disk-config.nix)
  # After NixOS installation, run nixos-generate-config to detect actual hardware
  # and update the kernel modules above if needed.

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