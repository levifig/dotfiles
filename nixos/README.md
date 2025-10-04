# NixOS Configuration

This directory contains NixOS system-level configurations for machines running NixOS.

## Structure

```
nixos/
├── hosts/              # Per-machine configurations
│   └── LFX004/
│       ├── configuration.nix         # Main system config
│       └── hardware-configuration.nix # Hardware-specific config
└── modules/            # Shared modules
    └── common.nix     # Common settings across all NixOS machines
```

## Installing NixOS on LFX004

### 1. Boot NixOS Installation Media

Download and boot from NixOS installation ISO.

### 2. Partition Disks

Example for a simple single-disk setup:

```bash
# List disks
lsblk

# Partition (example for /dev/sda)
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 512MiB 100%

# Format
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# Mount
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3. Generate Hardware Configuration

```bash
sudo nixos-generate-config --root /mnt
```

### 4. Clone Dotfiles and Setup

```bash
# Install git (in installer environment)
nix-shell -p git

# Clone dotfiles
git clone https://github.com/levifig/dotfiles.git /mnt/home/levifig/.dotfiles
cd /mnt/home/levifig/.dotfiles

# Copy hardware config to our repo
sudo cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/hosts/LFX004/

# Edit if needed
sudo nano ./nixos/hosts/LFX004/configuration.nix
```

### 5. Install NixOS

```bash
# Install from flake
sudo nixos-install --flake /mnt/home/levifig/.dotfiles#LFX004

# Set root password when prompted

# Reboot
reboot
```

### 6. Post-Installation Setup

After rebooting into your new NixOS system:

```bash
# Set user password
passwd

# Clone dotfiles (if not already there)
git clone https://github.com/levifig/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Apply Home Manager configuration
home-manager switch --flake ~/.dotfiles#levifig@LFX004
```

## Daily Usage

### System Configuration

**Rebuild system:**
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles
# Or specific host
sudo nixos-rebuild switch --flake ~/.dotfiles#LFX004
```

**Test configuration without switching:**
```bash
sudo nixos-rebuild test --flake ~/.dotfiles#LFX004
```

**Build for next boot (don't activate now):**
```bash
sudo nixos-rebuild boot --flake ~/.dotfiles#LFX004
```

**Rollback to previous generation:**
```bash
sudo nixos-rebuild switch --rollback
```

**List generations:**
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Home Manager Configuration

**Apply home configuration:**
```bash
home-manager switch --flake ~/.dotfiles#levifig@LFX004
```

**Rollback home configuration:**
```bash
home-manager rollback
```

## Updating

### Update System and Home Manager

```bash
# Update flake inputs
cd ~/.dotfiles
nix flake update

# Apply system changes
sudo nixos-rebuild switch --flake ~/.dotfiles#LFX004

# Apply home changes
home-manager switch --flake ~/.dotfiles#levifig@LFX004
```

### Update Only Specific Inputs

```bash
# Update only nixpkgs
nix flake lock --update-input nixpkgs

# Update only home-manager
nix flake lock --update-input home-manager
```

## Troubleshooting

### Configuration won't build

```bash
# Check syntax
sudo nixos-rebuild build --flake ~/.dotfiles#LFX004

# Show trace for errors
sudo nixos-rebuild switch --flake ~/.dotfiles#LFX004 --show-trace
```

### Roll back to previous generation

```bash
# From boot menu (GRUB/systemd-boot), select previous generation
# Or:
sudo nixos-rebuild switch --rollback
```

### Garbage collection

```bash
# Delete old generations
sudo nix-collect-garbage -d

# Delete old home-manager generations
nix-collect-garbage -d

# Or keep last N generations
sudo nix-collect-garbage --delete-older-than 30d
```

## Integration with Home Manager

The NixOS configuration handles system-level settings, while Home Manager (in `home-manager/hosts/LFX004.nix`) handles user-level configuration. Both are applied together:

1. **NixOS** (`nixos/hosts/LFX004/configuration.nix`):
   - System packages
   - Services (SSH, Docker, etc.)
   - Hardware configuration
   - Boot loader
   - Networking

2. **Home Manager** (`home-manager/hosts/LFX004.nix`):
   - User packages
   - Dotfiles
   - Shell configuration
   - User services

## Adding NixOS Configuration to Flake

The LFX004 NixOS configuration will be added to `flake.nix`:

```nix
nixosConfigurations = {
  LFX004 = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./nixos/hosts/LFX004/configuration.nix
    ];
  };
};
```

This allows: `sudo nixos-rebuild switch --flake ~/.dotfiles#LFX004`

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
