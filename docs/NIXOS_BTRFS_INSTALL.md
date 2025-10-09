# NixOS Installation Guide
# BTRFS with Subvolumes

This guide covers installing NixOS with BTRFS filesystem and declarative disk configuration using disko.

## Prerequisites

- NixOS minimal ISO (burned to USB)
- Network connection (wired or wireless)
- Your dotfiles already configured with BTRFS layout

## Overview

This setup uses:
- **BTRFS** with zstd compression for all partitions
- **Subvolumes** for flexible system management (@, @home, @nix, @swap, @snapshots, etc.)
- **Disko** for declarative disk partitioning
- **Weekly scrub** and **monthly balance** for BTRFS maintenance

## Phase 1: Boot and Prepare

### 1.1 Boot the NixOS ISO

Boot from the NixOS minimal ISO USB drive.

### 1.2 Set up networking

**For wired connection:**
```bash
# Should work automatically via DHCP
ip addr show
```

**For wireless connection:**
```bash
# Start the wireless network manager
sudo systemctl start wpa_supplicant

# Or use the interactive tool
sudo wpa_cli

# In wpa_cli:
> add_network
> set_network 0 ssid "YOUR_WIFI_SSID"
> set_network 0 psk "YOUR_WIFI_PASSWORD"
> enable_network 0
> quit
```

**Verify connectivity:**
```bash
ping -c 3 nixos.org
```

### 1.3 Identify your disk

```bash
# List all disks
lsblk

# Identify your primary disk (usually /dev/nvme0n1 or /dev/sda)
```

**Note the device path for the next steps!**

## Phase 2: Partition and Format

### 2.1 Partition the disk

We'll create:
- 512MB EFI partition
- Remaining space for BTRFS

```bash
# REPLACE /dev/nvme0n1 with your actual disk!
DISK=/dev/nvme0n1

# Create GPT partition table
sudo parted $DISK -- mklabel gpt

# Create EFI partition (512MB)
sudo parted $DISK -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -- set 1 esp on

# Create BTRFS partition (remaining space)
sudo parted $DISK -- mkpart primary btrfs 512MiB 100%
```

### 2.2 Format partitions

```bash
# Format EFI partition
sudo mkfs.fat -F32 ${DISK}p1

# Format BTRFS partition
sudo mkfs.btrfs -L nixos ${DISK}p2
```

### 2.3 Create BTRFS subvolumes

```bash
# Mount the BTRFS partition
sudo mount ${DISK}p2 /mnt

# Create subvolumes
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@persist
sudo btrfs subvolume create /mnt/@snapshots
sudo btrfs subvolume create /mnt/@swap
sudo btrfs subvolume create /mnt/@log

# List created subvolumes
sudo btrfs subvolume list /mnt

# Unmount
sudo umount /mnt
```

### 2.4 Mount subvolumes with proper options

```bash
# Mount options
OPTS="compress=zstd,noatime,space_cache=v2,discard=async"

# Mount root subvolume
sudo mount -o $OPTS,subvol=@ ${DISK}p2 /mnt

# Create mount points
sudo mkdir -p /mnt/{boot,home,nix,persist,.snapshots,swap,var/log}

# Mount boot partition
sudo mount ${DISK}p1 /mnt/boot

# Mount other subvolumes
sudo mount -o $OPTS,subvol=@home ${DISK}p2 /mnt/home
sudo mount -o $OPTS,subvol=@nix ${DISK}p2 /mnt/nix
sudo mount -o $OPTS,subvol=@persist ${DISK}p2 /mnt/persist
sudo mount -o $OPTS,subvol=@snapshots ${DISK}p2 /mnt/.snapshots
sudo mount -o noatime,subvol=@swap ${DISK}p2 /mnt/swap
sudo mount -o $OPTS,subvol=@log ${DISK}p2 /mnt/var/log

# Verify mounts
mount | grep /mnt
```

## Phase 3: Clone Dotfiles and Configure

### 3.1 Clone your dotfiles

```bash
# Install git (temporary)
nix-shell -p git

# Clone dotfiles to temporary location
git clone https://github.com/levifig/.dotfiles /tmp/dotfiles

# Copy to target location
sudo mkdir -p /mnt/home/levifig
sudo cp -r /tmp/dotfiles /mnt/home/levifig/.dotfiles
```

### 3.2 Update disk-config.nix with actual device

```bash
# Get the disk ID
ls -l /dev/disk/by-id/ | grep nvme

# Edit disk-config.nix and replace PLACEHOLDER with actual disk ID
# Example: nvme-Samsung_SSD_980_PRO_1TB_XXXXXXXXXXXX
sudo nano /mnt/home/levifig/.dotfiles/nixos/hosts/LFX004/disk-config.nix
```

**Update this line:**
```nix
device = "/dev/disk/by-id/nvme-PLACEHOLDER";
```

**To:**
```nix
device = "/dev/disk/by-id/nvme-YOUR-ACTUAL-DISK-ID";
```

### 3.3 Generate hardware configuration

```bash
# Generate hardware config
sudo nixos-generate-config --root /mnt

# Backup generated hardware config
sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hw-config-generated.nix

# Now merge the generated kernel modules and device UUIDs
# with your existing hardware-configuration.nix
```

**You need to:**
1. Copy kernel modules from generated config to your hardware-configuration.nix
2. Replace UUIDs in your hardware-configuration.nix with actual UUIDs from generated config

```bash
# Get UUIDs
sudo blkid

# Edit your hardware config
sudo nano /mnt/home/levifig/.dotfiles/nixos/hosts/LFX004/hardware-configuration.nix

# Replace all "REPLACE-WITH-ACTUAL-UUID" with actual UUIDs from blkid output
```

## Phase 4: Install NixOS

### 4.1 Run the installation

```bash
# Install NixOS from your flake
sudo nixos-install --flake /mnt/home/levifig/.dotfiles#LFX004

# This will:
# - Build the system configuration
# - Install all packages
# - Set up bootloader
# - Configure system
```

**Note:** This might take a while (30-60 minutes) depending on network speed and system performance.

### 4.2 Set root password

```bash
# When prompted, set a root password
# You can also set it after installation:
sudo nixos-enter --root /mnt
passwd root
exit
```

### 4.3 Set user password

```bash
sudo nixos-enter --root /mnt
passwd levifig
exit
```

## Phase 5: Post-Installation

### 5.1 Reboot

```bash
# Unmount all filesystems
sudo umount -R /mnt

# Reboot
sudo reboot
```

Remove the USB drive and boot into your new NixOS system.

### 5.2 Create swap file

After booting into your new system:

```bash
# Create 8GB swap file on BTRFS
sudo btrfs filesystem mkswapfile --size 8g /swap/swapfile

# Enable swap
sudo swapon /swap/swapfile

# Verify
swapon --show
```

The swap file is already configured in hardware-configuration.nix, so it will be automatically mounted on next boot.

### 5.3 Verify BTRFS setup

```bash
# Check BTRFS filesystem
sudo btrfs filesystem show /

# Check subvolumes
sudo btrfs subvolume list /

# Check compression stats
sudo compsize /
```

### 5.4 Check BTRFS maintenance services

```bash
# Check scrub service
systemctl status btrfs-scrub@-.service

# Check balance timer
systemctl status btrfs-balance.timer

# List all btrfs-related units
systemctl list-units | grep btrfs
```

### 5.5 Initial system update

```bash
# Update flake inputs
cd ~/.dotfiles
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake ~/.dotfiles#LFX004
```

## Phase 6: Finalization

### 6.1 Set up user environment

```bash
# Apply home-manager configuration
home-manager switch --flake ~/.dotfiles#levifig@LFX004

# Verify zsh is configured
echo $SHELL

# Check installed packages
which nvim git tmux
```

### 6.2 Configure SSH keys

```bash
# Create SSH directory
mkdir -p ~/.ssh/keys
chmod 700 ~/.ssh

# Copy your SSH keys
# (from backup or generate new ones)

# For git signing
ssh-keygen -t ed25519 -f ~/.ssh/keys/levifig-ed25519 -C "me@levifig.com"

# Add to GitHub/GitLab
cat ~/.ssh/keys/levifig-ed25519.pub
```

### 6.3 Set up additional services

```bash
# Start Docker (if needed)
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (already in config, but verify)
sudo usermod -aG docker levifig

# Start PostgreSQL (already enabled in config)
sudo systemctl status postgresql
```

### 6.4 Verify Gnome/Desktop setup

```bash
# Check display manager
systemctl status gdm

# Check desktop session
echo $XDG_SESSION_DESKTOP

# Test audio
pactl info
```

## BTRFS Management

### Creating snapshots

```bash
# Create a snapshot of root
sudo btrfs subvolume snapshot / /.snapshots/@-$(date +%Y%m%d-%H%M%S)

# Create a snapshot of home
sudo btrfs subvolume snapshot /home /.snapshots/@home-$(date +%Y%m%d-%H%M%S)

# List snapshots
sudo btrfs subvolume list /.snapshots
```

### Manual scrub

```bash
# Run a manual scrub
sudo btrfs scrub start /

# Check scrub status
sudo btrfs scrub status /
```

### Manual balance

```bash
# Run a manual balance
sudo btrfs balance start -dusage=50 -musage=50 /

# Check balance status
sudo btrfs balance status /
```

### Check disk usage

```bash
# BTRFS-specific disk usage
sudo btrfs filesystem usage /

# Traditional df
df -h
```

## Troubleshooting

### Boot issues

If the system doesn't boot:
1. Boot from the NixOS ISO again
2. Mount your partitions (same as in Phase 2.4)
3. Check configuration: `sudo nixos-enter --root /mnt`
4. Review logs: `journalctl -b`
5. Fix configuration and rebuild: `nixos-rebuild switch --flake ~/.dotfiles#LFX004`

### BTRFS errors

```bash
# Check filesystem for errors
sudo btrfs check /dev/nvme0n1p2

# Scrub filesystem
sudo btrfs scrub start /
```

### Disk full issues

```bash
# Check actual disk usage (BTRFS-aware)
sudo btrfs filesystem usage /

# Clear package cache
nix-collect-garbage -d

# Remove old generations
sudo nix-collect-garbage -d

# Clear systemd logs
sudo journalctl --vacuum-time=7d
```

### Swap file issues

```bash
# If swap file isn't working
sudo swapoff /swap/swapfile
sudo rm /swap/swapfile
sudo btrfs filesystem mkswapfile --size 8g /swap/swapfile
sudo swapon /swap/swapfile
```

## Advanced: Rollback to Snapshot

If you need to rollback to a snapshot:

```bash
# Boot from NixOS ISO
# Mount the BTRFS root partition (not the subvolume)
sudo mount /dev/nvme0n1p2 /mnt

# List snapshots
sudo btrfs subvolume list /mnt

# Rename current root
sudo mv /mnt/@ /mnt/@_broken

# Restore from snapshot (example)
sudo btrfs subvolume snapshot /mnt/.snapshots/@-20251008-120000 /mnt/@

# Unmount and reboot
sudo umount /mnt
sudo reboot
```

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Disko Documentation](https://github.com/nix-community/disko)
- [BTRFS Wiki](https://btrfs.wiki.kernel.org/)
- [BTRFS on NixOS](https://nixos.wiki/wiki/Btrfs)

---

*Last Updated: 2025-10-08 - Initial NixOS BTRFS installation guide for LFX004*
