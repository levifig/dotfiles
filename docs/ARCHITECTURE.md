# Dotfiles Architecture

## Directory Structure

### System-Level Configuration
- **`darwin/`** - nix-darwin system configuration (macOS system settings, services)
- **`nixos/`** - NixOS system configuration (Linux system settings, services)

### User-Level Configuration (Home Manager)
- **`home-manager/profiles/`** - Cross-platform profile compositions
  - `server.nix` - Minimal server environment
  - `development.nix` - Development tools and language runtimes
  - `platform.nix` - Platform engineering tools (K8s, IaC, cloud)
  - `workstation-headless.nix` - CLI workstation (server + dev + platform)
  - `workstation.nix` - Full GUI workstation
  - `container-host.nix` - Container orchestration deployment

- **`home-manager/platform/`** - Platform-specific user configurations
  - `darwin-base.nix` - macOS-specific user configs (aliases, tools)
  - `linux-base.nix` - Linux-specific user configs

- **`home-manager/modules/`** - Reusable configuration modules
  - `core/` - Essential configs (git, direnv, etc.)
  - `editors/` - Editor configurations
  - `shell/` - Shell configurations
  - `terminal/` - Terminal emulator configs
  - `fonts/` - Font management

- **`home-manager/hosts/`** - Host-specific configurations
  - Individual machine configs that import profiles

## Package Management Philosophy

### Nix First (Cross-Platform)
**All cross-platform CLI tools are managed via Nix:**
- Platform/infrastructure: terraform, ansible, kubectl, k9s, helm, argocd, etc.
- Shell utilities: zoxide, atuin, fzf, bat, eza, fd, etc.
- Development: language runtimes, build tools
- Container tools: docker-client, lazydocker

**Benefits:**
- Reproducible across all systems
- Rollback capabilities
- Declarative configuration
- Version pinning via flakes

### Homebrew (macOS-Specific Only)
**Only for things Nix can't handle well on macOS:**

1. **GUI Applications (Casks)**
   - Browsers, IDEs, productivity apps
   - Managed via `darwin/modules/homebrew.nix`

2. **Mac App Store Apps**
   - Via `mas` (which is installed via Nix!)
   - Declared in `darwin/modules/homebrew.nix`

3. **Services with launchd Integration**
   - postgresql@14 (for development)
   - Using Homebrew for better service management

4. **macOS-Specific Utilities Not in nixpkgs**
   - terminal-notifier
   - (Very few of these)

## Project-Specific Versions

**Using direnv + Nix flakes** (pure Nix approach):

```bash
# Create flake.nix in your project
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
      buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [
        python311
        nodejs_20
      ];
    };
  };
}

# Create .envrc
echo "use flake" > .envrc
direnv allow
```

**Why not mise?**
- Moving to pure Nix for reproducibility
- direnv automatically activates project environments
- Flakes provide exact version pinning via lock files

See [PROJECT_VERSIONS.md](PROJECT_VERSIONS.md) for detailed migration guide.

## Architecture Principles

### Profile Composition
Profiles build on each other:
```
server.nix
  ↓
development.nix → workstation-headless.nix → workstation.nix
  ↓                        ↓
platform.nix ──────────────┘
```

### Platform Separation
- **System configs** (`darwin/`, `nixos/`) - OS-level settings, can modify system
- **User configs** (`home-manager/`) - User environment, no root required
- **Platform-specific** (`home-manager/platform/`) - User configs that only make sense on one OS

### Package Location Guide

| Package Type | Location | Example |
|--------------|----------|---------|
| Cross-platform CLI | Nix profiles | kubectl, terraform, git |
| Language runtimes | `development.nix` | python, nodejs, ruby |
| Platform tools | `platform.nix` | k9s, argocd, helm |
| Shell tools | `workstation-headless.nix` | zoxide, atuin, bat |
| macOS CLI utils | `darwin-base.nix` | mas, duti, trash-cli |
| Linux CLI utils | `linux-base.nix` | (OS-specific tools) |
| macOS GUI apps | `darwin/modules/homebrew.nix` | browsers, IDEs |
| macOS services | `darwin/modules/homebrew.nix` | postgresql@14 |
| Mac App Store | `darwin/modules/homebrew.nix` | Xcode, Things |

## Migration from Homebrew

**Completed:**
- ✅ Moved all cross-platform CLI tools to Nix
- ✅ Organized tools into appropriate profiles
- ✅ Kept only macOS-specific items in Homebrew
- ✅ Removed redundant Homebrew management modules

**Result:**
- Homebrew brews: ~30 → **2** (terminal-notifier, postgresql@14)
- Nix packages: **All cross-platform tools**
- Homebrew casks: **GUI apps only** (can't be managed well by Nix on macOS)

## Benefits of This Architecture

1. **Reproducibility** - Same environment on any Nix-enabled system
2. **Rollback** - Nix generations let you undo changes
3. **Portability** - Profiles work across macOS, Linux, NixOS
4. **Modularity** - Compose exactly what you need per machine
5. **Clarity** - Clear separation of system vs user vs platform
6. **Maintainability** - Each tool has one obvious location

---

*Last Updated: 2025-10-08 - Initial architecture documentation*
