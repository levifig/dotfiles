# Managing Global CLI Tools

Guide for managing global tools installed via npm, pip, gem, cargo, etc.

## Philosophy

- **Prefer Nix packages**: Check nixpkgs first (most reliable, reproducible)
- **Language package managers for bleeding edge**: Use npm/pip/gem for tools not in nixpkgs
- **Nix manages the runtime**: Node, Python, Ruby come from Nix
- **User-local installs**: Keep global packages in `~/.npm-global`, `~/.local/bin`, etc.

## Installation Strategies

### 1. Available in nixpkgs (Preferred)

Add to appropriate profile:

```nix
# home-manager/profiles/development.nix
home.packages = with pkgs; [
  nodePackages.typescript
  nodePackages.prettier
  python3Packages.httpie
];
```

**Check availability:**
```bash
nix search nixpkgs typescript
nix search nixpkgs python3Packages.httpie
```

### 2. Not in nixpkgs → Use language package managers

The `cli-tools.nix` profile sets up prefixes for user-local installs:

#### npm packages
```bash
npm install -g @anthropics/claude-code
npm install -g @openai/codex-cli
npm install -g opencode

# List installed
npm list -g --depth=0
```

#### Python packages
```bash
pip install --user google-generativeai
pip install --user anthropic

# List installed
pip list --user
```

#### Ruby gems
```bash
gem install --user-install rails
gem install --user-install bundler

# List installed
gem list --user-install
```

#### Rust/Cargo
```bash
cargo install bat
cargo install ripgrep

# List installed
cargo install --list
```

## Configuration

The `cli-tools.nix` profile configures:

1. **NPM prefix**: `~/.npm-global` (avoids needing sudo)
2. **PATH additions**: Adds all language package manager bin directories
3. **Helper functions**: `npm-list`, `pip-list-user`, `gem-list-user`

## Example: Installing AI CLI Tools

```bash
# After applying home-manager configuration with cli-tools profile

# Claude Code (if not in nixpkgs)
npm install -g @anthropics/claude-code

# OpenAI Codex
npm install -g codex-cli

# Google Gemini
pip install --user google-generativeai

# Anthropic SDK
pip install --user anthropic
```

## Managing Updates

### Nix-managed packages
```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake .#levifig@LFX001 --impure
```

### Language package managers
```bash
# Update npm globals
npm update -g

# Update pip user packages
pip list --user --outdated
pip install --user --upgrade <package>

# Update gems
gem update --user-install
```

## Project-Specific Tools

For project-specific versions, use `flake.nix` + `direnv`:

```nix
# project/flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        nodejs_20
        nodePackages.typescript
      ];
    };
  };
}
```

```bash
# project/.envrc
use flake
```

## Troubleshooting

### npm packages not found after install
```bash
# Verify NPM prefix
npm config get prefix
# Should be: /Users/levifig/.npm-global

# Check PATH includes npm bin directory
echo $PATH | grep npm-global
```

### Conflicts between Nix and npm/pip versions
Nix versions in PATH come first. To temporarily use npm version:
```bash
# Use full path
~/.npm-global/bin/typescript-language-server

# Or temporarily adjust PATH
export PATH="$HOME/.npm-global/bin:$PATH"
```

## Best Practices

1. **Document what's installed via language package managers** (add comments to cli-tools.nix)
2. **Prefer Nix packages** when available (better reproducibility)
3. **Use direnv for project-specific tools** (avoids global version conflicts)
4. **Regular audits**: Review `npm list -g`, `pip list --user` periodically
5. **Commit configuration changes**: Document global tool decisions in git

---

*Last Updated: 2025-10-08 - Initial guide for managing global CLI tools*
