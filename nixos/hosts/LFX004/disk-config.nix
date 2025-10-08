# Declarative disk configuration for LFX004 using disko
# This configuration sets up BTRFS with subvolumes for optimal system management

{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Replace with actual device path during installation (e.g., /dev/nvme0n1 or /dev/sda)
        device = "/dev/disk/by-id/nvme-PLACEHOLDER";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            # Main BTRFS partition
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];  # Force overwrite
                subvolumes = {
                  # Root subvolume
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Home subvolume
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Nix store subvolume
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Persistent system state subvolume (optional)
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Snapshots subvolume
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Swap subvolume (no compression, no CoW)
                  "@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [
                      "noatime"
                    ];
                  };

                  # Log files subvolume (separate for easier rollback)
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Swap file configuration
  # Note: swapDevices will be configured after creating the swap file manually
  # swapDevices = [{
  #   device = "/swap/swapfile";
  #   size = 8192;  # 8GB
  # }];

  # Recommended: Enable BTRFS scrubbing service
  # This will be configured in configuration.nix

  # File system optimization notes:
  # - compress=zstd: Enables transparent compression with zstd algorithm (good balance)
  # - noatime: Don't update access time on file reads (improves performance)
  # - space_cache=v2: Use improved free space cache (recommended for BTRFS)
  # - discard=async: Enable asynchronous TRIM for SSDs (better performance)
}
