# Dotfiles - Nix + Home Manager Configuration

> Portable, reproducible development environment configuration using Nix and Home Manager

## Features

- 🔄 **Reproducible** - Exact same environment on any machine
- 🎯 **Declarative** - Define your entire system in code
- 🚀 **Cross-platform** - Works on macOS and Linux
- 🔧 **Modular** - Layered configuration system (base → platform → machine)
- 📦 **Self-contained** - All dependencies managed by Nix
- ⚡ **Fast setup** - One command to configure a new machine

## Quick Start

### Prerequisites

1. Install Nix:
```bash
# macOS
sh <(curl -L https://nixos.org/nix/install)

# Linux
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Enable flakes (add to `~/.config/nix/nix.conf`):
```
experimental-features = nix-command flakes
```

### Installation

#### Step-by-Step Setup

1. **Clone the repository:**
```bash
git clone https://github.com/levifig/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. **Verify the flake:**
```bash
nix flake check
nix flake show
```

3. **Install Home Manager:**
```bash
nix run home-manager/master -- init --switch
```

4. **Apply your configuration:**
```bash
# Auto-detect based on hostname
home-manager switch --flake ~/.dotfiles

# Or specify explicitly
home-manager switch --flake ~/.dotfiles#levifig@LFX001
```

#### Quick Setup (Bootstrap)
```bash
curl -L https://raw.githubusercontent.com/levifig/dotfiles/nix-migration/scripts/bootstrap.sh | bash
```

### Usage

#### Daily Commands

**Apply Configuration:**
```bash
# Quick apply
nix run ~/.dotfiles#switch

# Or manual
home-manager switch --flake ~/.dotfiles#levifig@LFX001
```

**Update All Packages:**
```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake .
```

**Rollback Changes:**
```bash
home-manager rollback
```

**List Generations:**
```bash
home-manager generations
```

**Test Before Applying:**
```bash
home-manager build --flake ~/.dotfiles#levifig@LFX001
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
├── flake.nix                 # Entry point with all machine definitions
├── home-manager/
│   ├── home.nix             # Base configuration (all machines)
│   ├── platform/
│   │   ├── darwin-base.nix  # macOS defaults
│   │   └── linux-base.nix   # Linux defaults
│   ├── profiles/            # Role-based configurations
│   │   ├── minimal.nix
│   │   ├── development.nix
│   │   ├── platform.nix
│   │   └── desktop.nix
│   ├── hosts/               # Machine-specific configs
│   │   ├── macbook-work.nix
│   │   ├── macbook-personal.nix
│   │   ├── linux-desktop.nix
│   │   └── linux-server.nix
│   └── modules/             # Reusable components
│       ├── core/           # Essential tools (git, ssh)
│       ├── shell/          # Shell configurations
│       ├── editors/        # Editor setups
│       ├── terminal/       # Terminal tools
│       └── development/    # Dev tools and languages
```

## Configuration Layers

The configuration uses a layered approach for maximum flexibility:

1. **Base Layer** (`home.nix`) - Common settings for all machines
2. **Platform Layer** (`platform/*.nix`) - OS-specific defaults
3. **Profile Layer** (`profiles/*.nix`) - Role-based bundles (can stack multiple)
4. **Host Layer** (`hosts/*.nix`) - Machine-specific overrides

Each layer can add or override settings from previous layers.

## Available Configurations

| Machine | Description | Platform | Command |
|---------|-------------|----------|---------|
| `levifig` | Auto-detected based on hostname | Any | `home-manager switch --flake .` |
| `levifig@LFX001` | Primary macOS machine (Apple Silicon) | Darwin | `home-manager switch --flake .#levifig@LFX001` |
| `levifig@LFX004` | Linux laptop (NixOS ready) | Linux | `home-manager switch --flake .#levifig@LFX004` |
| `levifig@macbook-work` | Work MacBook template | Darwin | `home-manager switch --flake .#levifig@macbook-work` |
| `levifig@macbook-personal` | Personal MacBook template | Darwin | `home-manager switch --flake .#levifig@macbook-personal` |
| `levifig@linux-desktop` | Linux desktop template | Linux | `home-manager switch --flake .#levifig@linux-desktop` |
| `levifig@linux-server` | Minimal Linux server template | Linux | `home-manager switch --flake .#levifig@linux-server` |

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

## Customization

### Adding a New Machine

1. Create a new host file: `home-manager/hosts/new-machine.nix`
2. Add the configuration to `flake.nix`:
```nix
"levifig@new-machine" = home-manager.lib.homeManagerConfiguration {
  modules = [
    ./home-manager/home.nix
    ./home-manager/platform/linux-base.nix  # or darwin-base.nix
    ./home-manager/hosts/new-machine.nix
  ];
};
```

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

## Included Tools

### Core
- Git (with delta, lazygit)
- Neovim
- tmux
- zsh (with oh-my-zsh)
- starship prompt

### Development
- Languages: Ruby, Python, Go, Node.js, Rust
- Containers: Docker, Podman
- Cloud: AWS CLI, Terraform, kubectl
- Databases: PostgreSQL, MySQL, Redis

### Utilities
- ripgrep, fd, fzf, bat, eza
- htop, btop
- jq, yq
- curl, wget, httpie

## Troubleshooting

### Nix command not found
```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Flakes not enabled
Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### Conflicts with existing files
Home Manager won't overwrite existing files. Either:
- Back up and remove conflicting files
- Use `home.file.<name>.force = true` in your config

### Platform detection issues
Explicitly specify your configuration:
```bash
home-manager switch --flake .#levifig@your-machine
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