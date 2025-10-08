# Version Management Strategy

## Overview

This document explains how versions are managed in the Nix configuration and what happens when you update packages.

## Types of Versions

### 1. **Dynamic Versions** (Auto-Update on Package Change)

These are computed at build time based on the actual package being used:

```nix
# home-manager/profiles/cli-tools.nix
let
  # Dynamically computed from pkgs.ruby
  rubyMajorMinor = pkgs.ruby.version.majMin or "3.4";
in
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.gem/ruby/${rubyMajorMinor}.0/bin"
  ];
}
```

**When updated:** Automatically updates when you change Ruby version in profiles
**Example:** Ruby gem path will always match the Ruby version in use

### 2. **Explicit Version Pins** (Intentional Choice)

Package selections with specific versions are **intentional choices**, not hardcoded mistakes:

```nix
# home-manager/profiles/development.nix
home.packages = with pkgs; [
  ruby_3_4              # Explicitly want Ruby 3.4
  python313             # Explicitly want Python 3.13
  nodejs_24             # Explicitly want Node.js 24
  rubyPackages_3_4.solargraph  # Must match ruby_3_4
];
```

**When updated:** Only when you explicitly change them
**Why:** Provides stability and control over language versions

### 3. **Generic Package References** (Latest Stable)

Packages without version numbers get the default/latest from nixpkgs:

```nix
home.packages = with pkgs; [
  go                    # Latest Go version
  gopls                 # Latest gopls
  rustc                 # Latest Rust
  nil                   # Latest Nix LSP (was: nixd)
];
```

**When updated:** On `nix flake update` (updates nixpkgs input)
**Why:** For tools where latest version is preferred

## How to Update Versions

### Update All Packages (nixpkgs bump)
```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake .#levifig@LFX001 --impure
```

This updates **generic packages** to their latest versions from nixpkgs.

### Change Language Version
```nix
# Edit home-manager/profiles/development.nix

# Old
python313
python313Packages.pip

# New
python314
python314Packages.pip
```

**Important:** Dynamic paths (like Ruby gems) will automatically adjust.

### Check Available Versions
```bash
# Search for available versions
nix search nixpkgs python3
nix search nixpkgs ruby_
nix search nixpkgs nodejs

# See what's available
nix eval nixpkgs#python313.version
nix eval nixpkgs#ruby_3_4.version.majMin
```

## Version Coordination

### Development Shell Versions

The `devShells` in `flake.nix` should match your profile versions:

```nix
# flake.nix devShells should align with profiles/development.nix
devShells = forAllSystems (system: {
  ruby = pkgs.mkShell {
    buildInputs = with pkgs; [
      ruby_3_4                    # ← Matches development.nix
      rubyPackages_3_4.solargraph # ← Matches development.nix
    ];
  };
});
```

**When to update:** Keep these in sync with your profile package versions.

### Special Cases

#### PostgreSQL (Homebrew)
```nix
# darwin/modules/homebrew.nix
brews = [
  "postgresql@18"  # Pinned for launchd integration
];
```

**Why pinned:** Homebrew formula convention, better macOS integration

#### NixOS State Version
```nix
# nixos/hosts/LFX004/configuration.nix
system.stateVersion = "24.05";  # NEVER change this!
```

**Why pinned:** NixOS uses this for migration compatibility. Read the comments in the file!

## Best Practices

1. **Use explicit versions for languages** - Provides stability across team/machines
2. **Use generic names for tools** - Get latest bug fixes automatically
3. **Keep devShells in sync** - Match your profile package versions
4. **Document version decisions** - Add comments explaining why a specific version is chosen
5. **Test after updates** - Run `nix flake check` after version changes

## Troubleshooting

### Ruby gems not found after updating Ruby
Dynamic path should handle this automatically. If issues persist:
```bash
# Check what version is computed
nix eval .#homeConfigurations.levifig@LFX001.config.home.sessionPath

# Verify Ruby version
ruby --version

# Check gem path
echo $GEM_PATH
```

### Version conflicts between Nix and language package managers
```bash
# Nix packages have priority in PATH
which python3  # Should show Nix store path

# For debugging, check order
echo $PATH | tr ':' '\n' | grep -E '(nix|npm|gem|cargo)'
```

### Updating causes rebuild of many packages
This is normal when changing language versions. The Nix store keeps old versions for rollback:
```bash
# Clean old versions
nix run .#clean -- 30  # Remove older than 30 days
```

---

*Last Updated: 2025-10-08 - Initial versioning strategy documentation*
