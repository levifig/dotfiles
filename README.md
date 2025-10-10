# Dotfiles - Nix + Home Manager Configuration

> Portable, reproducible development environment configuration using Nix and Home Manager

## Quick Start

```bash
# Install Nix with Determinate installer (enables flakes automatically)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone repository
git clone --recurse-submodules https://github.com/levifig/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Verify configuration
nix flake check

# Apply configuration
# macOS (nix-darwin):
nix run nix-darwin -- switch --flake .#LFX001

# Linux (home-manager):
nix run home-manager/master -- switch --flake .#levifig@LFX004 --impure
```

After the first run, `darwin-rebuild` (macOS) or `home-manager` (Linux) will be available in your PATH.

---

## Features

- 🔄 **Reproducible** - Exact same environment on any machine
- 🎯 **Declarative** - Define your entire system in code
- 🚀 **Cross-platform** - Works on macOS and Linux
- 🔧 **Modular** - Layered configuration system (base → platform → machine)
- 📦 **Self-contained** - All dependencies managed by Nix
- ⚡ **Fast setup** - One command to configure a new machine

## Installation

### Prerequisites

Install Nix using the **Determinate Nix Installer** (recommended):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**Why Determinate installer?**
- ✅ Enables flakes automatically (no manual config needed)
- ✅ Better uninstall support
- ✅ Optimized defaults for modern Nix usage
- ✅ Works on macOS (Intel & Apple Silicon) and Linux

After installation, restart your shell or run: `. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`

### Step-by-Step Setup

1. **Clone the repository:**
```bash
git clone --recurse-submodules https://github.com/levifig/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**Note:** The `--recurse-submodules` flag initializes the private fonts submodule. If you cloned without it:
```bash
git submodule update --init config/fonts
```

2. **Verify the flake:**
```bash
nix flake check
nix flake show
```

3. **Apply your configuration:**
```bash
# Apply configuration (replace LFX001 with LFX004 for Linux systems)
nix run home-manager/master -- switch --flake ~/.dotfiles#levifig@LFX001 --impure
```

**Note:** The `--impure` flag is required for configurations that use the private fonts submodule (workstation profiles).

After the first run, you can use the shorter `home-manager switch --flake ...` command directly.

#### Quick Setup (Bootstrap)

One-command setup for new machines:

```bash
# From the web (will clone repo and setup everything)
curl -L https://raw.githubusercontent.com/levifig/dotfiles/main/apps/bootstrap.sh | bash

# Or if repo is already cloned
cd ~/.dotfiles && nix run .#bootstrap
```

The bootstrap script will:
- Install Nix using Determinate installer (flakes enabled automatically)
- Clone this repository to `~/.dotfiles`
- Backup existing configurations
- Apply your configuration automatically

### Usage

#### Daily Commands

**Apply Configuration:**
```bash
# macOS workstation (nix-darwin with integrated home-manager)
darwin-rebuild switch --flake ~/.dotfiles

# macOS - home-manager only (faster, when only user configs changed)
home-manager switch --flake ~/.dotfiles

# Linux laptop (standalone home-manager)
home-manager switch --flake ~/.dotfiles#levifig@LFX004 --impure
```

**Which command to use on macOS?**
- **`darwin-rebuild switch`** - Use when changing system settings, Homebrew packages, or darwin configuration
- **`home-manager switch`** - Use for faster rebuilds when only changing user dotfiles, shell configs, or packages

Your home-manager is integrated as a nix-darwin module, so `darwin-rebuild` rebuilds both system and user configs, while `home-manager switch` only rebuilds user configs.

**Update All Packages:**
```bash
cd ~/.dotfiles
nix flake update
darwin-rebuild switch --flake ~/.dotfiles  # macOS
# or
home-manager switch --flake ~/.dotfiles    # Linux
```

**Rollback Changes:**
```bash
# macOS
darwin-rebuild rollback
# or for home-manager only
home-manager rollback

# Linux
home-manager rollback
```

**List Generations:**
```bash
# macOS system
darwin-rebuild --list-generations
# or home-manager only
home-manager generations

# Linux
home-manager generations
```

**Test Before Applying:**
```bash
# macOS
darwin-rebuild build --flake ~/.dotfiles

# Linux
home-manager build --flake ~/.dotfiles#levifig@LFX004
```

#### Development Shells

**Enter a shell with specific language version:**
```bash
# Python 3.13 environment
nix develop ~/.dotfiles#python
python --version

# Ruby 3.4 environment
nix develop ~/.dotfiles#ruby
ruby --version

# Node.js 24 environment
nix develop ~/.dotfiles#node
node --version

# Go 1.24 environment
nix develop ~/.dotfiles#go
go version
```

**Project-Specific Versions:**

For projects needing different versions, create a `flake.nix` in the project:

```nix
{
  description = "Project with Python 3.11";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python311
            python311Packages.pip
          ];
        };
      }
    );
}
```

Then use: `nix develop` in that project directory.

#### Package Management

**Search for packages:**
```bash
nix search nixpkgs python
```

**Install package temporarily:**
```bash
nix shell nixpkgs#ripgrep
```

**See what's installed:**
```bash
home-manager packages
```

## Configuration Structure

```
.
├── flake.nix                 # Entry point with darwin + home-manager configurations
├── darwin/                   # nix-darwin system configuration (macOS only)
│   ├── configuration.nix     # Main darwin config
│   └── modules/
│       ├── homebrew.nix      # Declarative Homebrew packages
│       ├── system.nix        # macOS system settings
│       └── dock.nix          # Dock configuration (optional)
├── home-manager/             # User-level configuration (all platforms)
│   ├── home.nix              # Base configuration (all machines)
│   ├── platform/
│   │   ├── darwin-base.nix   # macOS user defaults
│   │   └── linux-base.nix    # Linux user defaults
│   ├── profiles/             # Role-based configurations
│   │   ├── server.nix
│   │   ├── workstation-headless.nix
│   │   ├── workstation.nix
│   │   ├── development.nix
│   │   └── platform.nix
│   ├── hosts/                # Machine-specific configs
│   │   ├── LFX001.nix        # Primary macOS machine
│   │   └── LFX004.nix        # Linux laptop
│   └── modules/              # Reusable components
│       ├── core/             # Essential tools (git, ssh)
│       ├── fonts/            # Font management
│       ├── shell/            # Shell configurations (zsh, bash)
│       ├── editors/          # Editor setups (neovim, vim)
│       ├── terminal/         # Terminal tools (tmux, ghostty)
│       ├── desktop/          # GUI apps (aerospace, hammerspoon)
│       ├── tools/            # Development tools (opencode, claude)
│       └── darwin/           # macOS-specific user configs
├── config/                   # Actual configuration files deployed to ~
│   ├── zsh/                  # ZSH configuration
│   ├── nvim/                 # Neovim config
│   ├── tmux/                 # Tmux config
│   ├── opencode/             # OpenCode config
│   └── ...                   # Other app configs
└── .fonts/
    └── private/              # Private fonts (git submodule)
```

## Configuration Layers

The configuration uses a layered approach for maximum flexibility:

### macOS (nix-darwin + home-manager)
1. **Darwin System Layer** (`darwin/configuration.nix`) - macOS system settings, Homebrew
2. **Home-Manager Base** (`home.nix`) - Common user settings for all machines
3. **Platform Layer** (`platform/darwin-base.nix`) - macOS user defaults
4. **Profile Layer** (`profiles/*.nix`) - Role-based bundles (can stack multiple)
5. **Host Layer** (`hosts/LFX001.nix`) - Machine-specific overrides

### Linux (standalone home-manager)
1. **Home-Manager Base** (`home.nix`) - Common user settings for all machines
2. **Platform Layer** (`platform/linux-base.nix`) - Linux user defaults
3. **Profile Layer** (`profiles/*.nix`) - Role-based bundles (can stack multiple)
4. **Host Layer** (`hosts/LFX004.nix`) - Machine-specific overrides

Each layer can add or override settings from previous layers.

## Profiles as Templates

Profiles serve as reusable "templates" for deployment patterns. Instead of flake templates (which bootstrap new repos), profiles let you compose standardized configurations for specific machine roles:

### Using Profiles for Deployment Patterns

Create role-specific profiles for different machine types:

```nix
# profiles/container-host.nix - Standard docker host setup
{ pkgs, ... }: {
  home.packages = with pkgs; [
    docker-compose
    kubectl
    helm
    lazydocker
  ];
  # ... container-specific configs
}

# profiles/k8s-node.nix - Kubernetes worker node
{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubelet
    containerd
  ];
  # ... k8s-specific configs
}
```

### Composing Profiles in Host Files

Minimal host files import and compose profiles:

```nix
# hosts/docker-prod-01.nix
{ ... }: {
  imports = [
    ../profiles/container-host.nix  # Docker tools
    ../profiles/monitoring.nix       # Prometheus, Grafana agents
    ../profiles/platform.nix         # Platform engineering tools
  ];

  # Only unique configuration
  networking.hostName = "docker-prod-01";
  services.docker.storageDriver = "overlay2";
}
```

### Benefits Over Flake Templates

- **Composable**: Mix multiple profiles (container + monitoring + backup)
- **Centralized Updates**: Change profile, all hosts inherit updates
- **Version Controlled**: All configs in one repo, track changes together
- **Type Safe**: Nix validates entire composition

### Example: Infrastructure Fleet

```
profiles/
├── container-host.nix    # Docker/Podman setup
├── k8s-node.nix         # Kubernetes worker
├── monitoring.nix       # Observability stack
└── database-host.nix    # DB-specific tuning

hosts/
├── docker-01.nix → [container-host, monitoring]
├── k8s-worker-01.nix → [k8s-node, monitoring]
└── db-primary.nix → [database-host, monitoring]
```

Each host file stays minimal (5-10 lines), while profiles contain the bulk of configuration.

## Helper Scripts

Convenient commands for daily operations:

```bash
# Setup & Installation
nix run .#bootstrap       # Bootstrap new machine (install Nix, HM, apply config)

# Daily Operations
nix run .#build           # Build without switching (test changes)
nix run .#switch          # Build and activate configuration
nix run .#rollback        # Rollback to previous generation

# Maintenance
nix run .#update          # Update flake inputs (with optional rebuild)
nix run .#clean           # Garbage collect old generations (default: 30 days)
nix run .#clean -- 60     # Custom: 60 days
```

All scripts auto-detect your platform (darwin/nixos/home-manager) and configuration.

**Scripts location**: `apps/` directory - all executable helper scripts in one place.

## Available Configurations

| Machine | Description | Platform | Command |
|---------|-------------|----------|---------|
| `levifig` | Auto-detected based on hostname | Any | `home-manager switch --flake .` |
| `levifig@LFX001` | Primary macOS machine (Apple Silicon) | Darwin | `home-manager switch --flake .#levifig@LFX001 --impure` |
| `levifig@LFX004` | Linux laptop (NixOS ready) | Linux | `home-manager switch --flake .#levifig@LFX004 --impure` |

### Creating Additional Configurations

To add a new machine, create a host file and add it to `flake.nix`:

```nix
# home-manager/hosts/new-machine.nix
{ config, pkgs, lib, ... }: {
  imports = [
    ../platform/darwin-base.nix  # or linux-base.nix
    ../profiles/development.nix   # Choose your profiles
  ];

  home.packages = with pkgs; [
    # Machine-specific packages
  ];

  programs.git = {
    userEmail = "your@email.com";
    signing.key = "~/.ssh/keys/your-key.pub";
  };
}
```

Then add to `flake.nix`:
```nix
"${user}@new-machine" = home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs-darwin {
    system = "aarch64-darwin";  # or x86_64-linux
    config.allowUnfree = true;
    overlays = [ packageOverrides ];
  };
  modules = [
    ./home-manager/home.nix
    ./home-manager/hosts/new-machine.nix
    {
      home = {
        username = user;
        homeDirectory = "/Users/${user}";  # or /home/${user}
      };
      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
    }
  ];
};
```

## Development Shells

Launch project-specific development environments:

```bash
# Default shell with basic tools
nix develop ~/.dotfiles

# Language-specific shells
nix develop ~/.dotfiles#ruby
nix develop ~/.dotfiles#python
nix develop ~/.dotfiles#node
nix develop ~/.dotfiles#go
```

## User Information

Configure your git identity in your host-specific configuration:

### Setup Your Git Identity

Edit your host configuration file:

```nix
# home-manager/hosts/your-machine.nix
{
  programs.git = {
    userName = "Your Name";
    userEmail = "you@example.com";
    signing.key = "ssh-ed25519 AAAA...";  # Your SSH public key
  };
}
```

Host files have clear `🔧 CUSTOMIZE` markers to help you find what to edit.

### Multiple Identities

**Different per machine:**

```nix
# Personal machine (hosts/personal-machine.nix)
programs.git.userEmail = "me@example.com";

# Work machine (hosts/work-machine.nix)
programs.git.userEmail = "work@company.com";
```

**Directory-based on same machine:**

```nix
programs.git.includes = [
  {
    condition = "gitdir:~/Work/";
    contents.user.email = "work@company.com";
  }
];
```

This is the standard Home-Manager pattern - simple and conventional.

## Forking This Repository

Want to use these dotfiles as a starting point? Here's how:

### Quick Start

1. **Fork this repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR-USERNAME/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. **Customize your identity** - Look for `🔧 CUSTOMIZE` markers in host files:
   ```bash
   # Edit your host file
   nvim home-manager/hosts/your-machine.nix

   # Update these fields:
   programs.git = {
     userName = "Your Name";      # ← Change this
     userEmail = "you@email.com"; # ← Change this
     signing.key = "ssh-ed25519 AAAA..."; # ← Change this
   };
   ```

4. **Apply configuration:**
   ```bash
   nix run .#switch
   ```

### What to Customize

The information in this repo (name, email, SSH public key) is **already public** on GitHub - it's not sensitive data. But you'll want to change it to yours:

- ✅ Git username/email (in host files)
- ✅ SSH public keys (it's called "public" for a reason!)
- ✅ GitHub usernames
- ✅ Machine-specific settings

### Security Note

**Nothing sensitive is in this repo:**
- SSH **private** keys are in 1Password (never in git)
- API tokens should use 1Password/environment variables
- Passwords are never committed

The data in host files is the same information already on every git commit you make.

## Customization

### Adding a New Machine

See the [Creating Additional Configurations](#creating-additional-configurations) section above for detailed instructions on adding new machines.

### Adding New Tools

Edit the appropriate module in `home-manager/modules/` or add packages to your host configuration:

```nix
# In hosts/your-machine.nix
home.packages = with pkgs; [
  new-package
];
```

### Modifying Shell Configuration

Edit `home-manager/modules/shell/zsh.nix` or create machine-specific overrides:

```nix
# In hosts/your-machine.nix
programs.zsh.initExtra = ''
  # Your custom zsh config
'';
```

## macOS-Specific Features

### Declarative Homebrew Management (nix-homebrew)

Homebrew packages and casks are now managed declaratively through Nix. This means:
- Homebrew apps are part of your Nix generations
- You can rollback Homebrew state with `nix run .#rollback`
- Configuration is version controlled and reproducible

**Configuration:**
- Location: `darwin/modules/homebrew.nix`
- Organized by category (security, development, browsers, etc.)
- Includes formulas (CLI), casks (GUI apps), and Mac App Store apps

**Adding Homebrew Packages:**

```nix
# darwin/modules/homebrew.nix
homebrew = {
  enable = true;

  brews = [
    "new-cli-tool"
  ];

  casks = [
    "new-gui-app"
  ];

  masApps = {
    "App Name" = 123456789;  # Find ID with: mas search "App Name"
  };
};
```

After editing, run `nix run .#switch` to apply changes.

### Declarative Dock (Optional)

Manage your macOS Dock declaratively. **Currently disabled by default.**

**To enable:**

Edit `darwin/modules/dock.nix` and set `enable = true`:

```nix
darwin.dock = {
  enable = true;  # Change from false to true
  username = "levifig";
  entries = [
    { path = "/Applications/Arc.app/"; }
    { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    # Add more apps...
  ];
};
```

The dock will be automatically configured on next `darwin-rebuild switch`.

## Private Fonts

This repository uses a private git submodule for licensed fonts. The fonts are stored in a separate private repository and deployed via Nix.

### Setup

**On initial clone:**
```bash
git clone --recurse-submodules https://github.com/levifig/dotfiles.git ~/.dotfiles
```

**If already cloned:**
```bash
cd ~/.dotfiles
git submodule update --init .fonts/private
```

### How It Works

1. **Source**: `.fonts/private` is a git submodule pointing to `github.com/levifig/fonts` (private)
2. **Build**: Nix copies fonts to `/nix/store/.../private-fonts/`
3. **Deploy**: Home-manager symlinks to system font directories:
   - macOS: `~/Library/Fonts/`
   - Linux: `~/.local/share/fonts/`
4. **Available**: All applications see the fonts through normal OS font APIs

### Font Structure

```
.fonts/private/
├── FREE/           # Open-source fonts
│   └── Font_Name/
│       ├── OTF/    # OpenType fonts
│       ├── TTF/    # TrueType fonts (fallback)
│       └── VF/     # Variable fonts (preferred)
└── PAID/           # Licensed fonts (private repo only)
    └── PragmataPro_0.902/
        └── *.otf
```

**Priority**: VF (Variable) > OTF (OpenType) > TTF (TrueType)

### Important Notes

- ✅ Fonts stay in private repository - licenses protected
- ✅ Public dotfiles only contain submodule reference
- ⚠️ Requires `--impure` flag when building (uses absolute path)
- ⚠️ Only deployed on **workstation** profiles (GUI), not headless/server

### Adding New Fonts

1. Add font files to `github.com/levifig/fonts` repository
2. Update submodule in dotfiles:
```bash
cd ~/.dotfiles/.fonts/private
git pull origin main
cd ../..
git add .fonts/private
git commit -m "Update fonts submodule"
```

3. Rebuild configuration:
```bash
home-manager switch --flake .#levifig@LFX001 --impure
```

## Included Tools

### Core
- Git (with delta, lazygit, 1Password SSH signing)
- Neovim (LazyVim configuration)
- tmux (with plugins)
- zsh (with autosuggestions, syntax highlighting)
- starship prompt
- Fonts (private submodule - workstation profiles only)

### Development
- Languages: Ruby 3.4, Python 3.13, Go, Node.js 24, Rust
- Containers: Docker, Podman
- Cloud: AWS CLI, Google Cloud SDK, Azure CLI
- IaC: Terraform (with plugins), Terragrunt, Ansible
- Kubernetes: kubectl, helm, k9s, argocd
- Databases: PostgreSQL, MySQL, Redis

### Utilities
- Modern alternatives: ripgrep, fd, fzf, bat, eza, zoxide
- System monitoring: htop, btop
- Data: jq, yq
- Network: curl, wget, httpie
- Productivity: atuin, direnv, mise

## Troubleshooting

### Nix command not found
After installing Nix, restart your shell or run:
```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Flakes not enabled
If using the Determinate Nix installer, flakes are enabled by default. For manual installations, add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### Fonts not loading / `path does not exist` error
If you see errors about `.fonts/private` not existing:

1. **Initialize the submodule:**
```bash
cd ~/.dotfiles
git submodule update --init .fonts/private
```

2. **Rebuild with `--impure` flag:**
```bash
home-manager switch --flake .#levifig@LFX001 --impure
```

The `--impure` flag is **required** for workstation profiles that use the fonts module, because it accesses the submodule via absolute path.

### Fonts not appearing in applications

1. **Verify fonts are installed:**
```bash
# macOS
fc-list | grep -i PragmataPro

# Check nix store
ls /nix/store/*private-fonts*/share/fonts/
```

2. **Rebuild font cache (Linux):**
```bash
fc-cache -fv
```

3. **Restart applications** - Some apps only load fonts at startup

### Submodule access denied

If you get "Permission denied" when cloning/updating the fonts submodule:

1. **Verify SSH access to private repo:**
```bash
ssh -T git@github.com
```

2. **Check you have access to `github.com/levifig/fonts`** (private repository)

3. **Update submodule URL if needed:**
```bash
cd ~/.dotfiles
git config --file=.gitmodules submodule..fonts/private.url git@github.com:levifig/fonts.git
git submodule sync
git submodule update --init .fonts/private
```

### Conflicts with existing files
Home Manager won't overwrite existing files. Either:
- Back up and remove conflicting files
- Use `home.file.<name>.force = true` in your config

### Platform detection issues
Explicitly specify your configuration:
```bash
home-manager switch --flake .#levifig@your-machine --impure
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both macOS and Linux if possible
5. Submit a pull request

## License

MIT - See LICENSE file for details

## Acknowledgments

- [Nix](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- The Nix community for excellent documentation and examples