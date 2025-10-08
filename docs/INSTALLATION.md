# Installation Guide

## Quick Install (You Are Here!)

You've already cloned and configured the dotfiles. Now we need to install Nix and apply the configuration.

### Prerequisites

- macOS 10.15+ (Catalina or newer) or Linux
- Admin/sudo access
- Internet connection

### Step 1: Install Nix

**Recommended: Determinate Systems Installer (better for macOS)**

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**Why this installer?**
- ✅ Better macOS compatibility (handles new volumes properly)
- ✅ Enables flakes by default
- ✅ Cleaner installation process
- ✅ Easy uninstall

**Alternative: Official Nix Installer**

```bash
sh <(curl -L https://nixos.org/nix/install)
```

**After installation:**
```bash
# Close and reopen your terminal, or source Nix:
# Apple Silicon
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Intel Mac
source ~/.nix-profile/etc/profile.d/nix.sh

# Verify installation
nix --version
```

### Step 2: Enable Flakes (if using official installer)

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf <<EOF
experimental-features = nix-command flakes
EOF
```

**Note:** Determinate installer enables flakes by default - skip this step!

### Step 3: Install nix-darwin (macOS only)

```bash
cd ~/.dotfiles

# Build and activate nix-darwin
nix run nix-darwin -- switch --flake .

# After first run, use the installed command:
darwin-rebuild switch --flake ~/.dotfiles
```

### Step 4: Apply Home Manager Configuration

```bash
cd ~/.dotfiles

# Determine your configuration name
# Format: username@hostname
hostname -s  # Your hostname
whoami       # Your username

# Apply configuration
# Replace LFX001 with your hostname from above
nix run home-manager/master -- switch --flake .#levifig@LFX001

# Or if you have a generic config:
nix run home-manager/master -- switch --flake .#levifig
```

### Step 5: Verify Installation

```bash
# Check Nix packages are available
python --version   # Should show Python 3.13.x
node --version     # Should show Node 24.x
go version         # Should show Go 1.x

# Check direnv is working
direnv --version

# Check home-manager
home-manager --version
```

### Step 6: Install Homebrew Packages (macOS only)

Our configuration uses Homebrew for GUI apps and macOS-specific tools:

```bash
# Homebrew should already be installed on most Macs
# If not:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apply Homebrew configuration (casks, Mac App Store apps)
# This is managed by nix-darwin, so it should happen automatically
# But you can manually trigger:
brew bundle --file=/dev/null  # Forces homebrew module to run
```

## Alternative: Use Bootstrap Script

If you prefer an automated approach:

```bash
cd ~/.dotfiles
chmod +x apps/bootstrap.sh
./apps/bootstrap.sh
```

**What it does:**
1. Installs Nix
2. Enables flakes
3. Installs nix-darwin (macOS)
4. Installs Home Manager
5. Applies configuration
6. Backs up existing configs

## Host-Specific Configuration

### Current Hosts

Your dotfiles include configurations for:
- **LFX001** (macOS - your current machine?)
- **LFX004** (Dual boot macOS/NixOS)
- **macbook-work** (Work machine template)

### Configure Your Machine

If your hostname doesn't match, update the flake:

```bash
# Check current hostname
hostname -s

# If it's different from LFX001, either:
# 1. Create a new host config:
cp home-manager/hosts/LFX001.nix home-manager/hosts/$(hostname -s).nix

# 2. Or update flake.nix to add your hostname
# Edit flake.nix and add your host to homeConfigurations
```

## Daily Commands

Once installed, use these helper scripts:

```bash
# Build configuration (check for errors)
nix run .#build

# Apply changes
nix run .#switch
# Or: darwin-rebuild switch --flake ~/.dotfiles (macOS)
# Or: home-manager switch --flake ~/.dotfiles

# Rollback to previous generation
nix run .#rollback
# Or: darwin-rebuild --rollback

# Update all flake inputs
nix run .#update

# Clean old generations
nix run .#clean
```

## Troubleshooting

### "error: experimental feature 'flakes' is disabled"

```bash
# Flakes not enabled
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Restart nix daemon (macOS)
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
```

### "command not found: nix"

```bash
# Nix not in PATH
# Source the nix profile:
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Or restart your terminal
```

### "error: getting status of '/nix/store/...': No such file or directory"

```bash
# Nix store corrupted or incomplete
# Repair the store:
sudo nix-store --verify --check-contents --repair

# Or reinstall Nix (nuclear option)
```

### Build fails with "attribute 'homeConfigurations.levifig@XXX' missing"

```bash
# Your hostname isn't configured
# Check available configurations:
nix flake show .

# Use a different config or create one for your hostname
```

### Homebrew casks not installing

```bash
# Homebrew needs to be installed separately
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then nix-darwin will manage packages
darwin-rebuild switch --flake ~/.dotfiles
```

### "error: access to URI 'github:...' is forbidden in pure evaluation mode"

```bash
# Flake inputs need to be updated
nix flake update

# Or use impure mode (not recommended)
nix build --impure
```

## Platform-Specific Notes

### macOS

- **nix-darwin** manages system-level configuration
- **Homebrew** handles GUI apps (casks) and services
- **1Password SSH agent** needs manual setup (see README.md)

### NixOS (LFX004)

- System configuration in `nixos/hosts/LFX004/`
- Rebuild with: `sudo nixos-rebuild switch --flake ~/.dotfiles`
- Services (PostgreSQL, etc.) managed via systemd

### Linux (non-NixOS)

- Home Manager only (no system management)
- Install via: `nix run home-manager/master -- switch --flake .`

## Next Steps

1. **Customize your configuration**
   - Edit `home-manager/hosts/$(hostname -s).nix`
   - Add personal Git identity, SSH keys, etc.

2. **Set up project environments**
   - Read `docs/DIRENV_FLAKES.md`
   - Create flake.nix in your projects

3. **Migrate from mise**
   - Read `docs/PROJECT_VERSIONS.md`
   - Uninstall mise: `brew uninstall mise`

4. **Review architecture**
   - Read `docs/ARCHITECTURE.md`
   - Understand the profile system

## Uninstallation

### Remove Nix (if needed)

**Determinate Systems installer:**
```bash
/nix/nix-installer uninstall
```

**Official installer (macOS):**
```bash
# Follow official guide:
# https://nixos.org/manual/nix/stable/installation/uninstall.html
```

---

*Last Updated: 2025-10-08 - Initial installation guide*
