# Hardware configuration for LFX004
# This file will be generated during NixOS installation
# Run: nixos-generate-config --show-hardware-config > hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # This is a placeholder - will be replaced by actual hardware scan
  # during NixOS installation

  # boot.initrd.availableKernelModules = [ ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  # Placeholder filesystem configuration for flake validation
  # Replace with actual configuration during installation
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/placeholder";
    fsType = "ext4";
  };

  # swapDevices = [ ];

  # networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Hardware features
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # OR for AMD:
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}