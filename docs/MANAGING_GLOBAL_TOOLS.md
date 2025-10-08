# Managing Global CLI Tools

Guide for managing global tools installed via npm, pip, gem, cargo, etc.

## Philosophy

- **Prefer Nix packages**: Check nixpkgs first (most reliable, reproducible)
- **Language package managers for bleeding edge**: Use npm/pip/gem for tools not in nixpkgs
- **Nix manages the runtime**: Node, Python, Ruby come from Nix
- **User-local installs**: Keep global packages in `~/.npm-global`, `~/.local/bin`, etc.

## Installation Strategies

### 1. Available in nixpkgs (Preferred) ✅

**Always check nixpkgs first!** Many popular CLI tools are already packaged:

```bash
# Search for the tool
nix search nixpkgs bun
nix search nixpkgs uv
nix search nixpkgs claude-code

# Check specific package managers
nix search nixpkgs nodePackages.
nix search nixpkgs python3Packages.
```

If found, add to `home-manager/profiles/development.nix`:

```nix
home.packages = with pkgs; [
  # Language runtimes/package managers
  bun                      # Fast JS runtime (better than npm install -g bun)
  uv                       # Fast Python installer (better than pip install uv)

  # Node packages
  nodePackages.typescript  # Better than npm install -g typescript
  nodePackages.prettier

  # Python packages
  python3Packages.httpie
];
```

**Why prefer nixpkgs:**
- ✅ Reproducible across machines
- ✅ Rollback support
- ✅ No version conflicts
- ✅ Automatically updated with `nix flake update`

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

## Quick Reference: Common CLI Tools

### Package Manager Tools (✅ In nixpkgs - add to Nix config)

```nix
home.packages = with pkgs; [
  # JavaScript/TypeScript
  bun                    # All-in-one JavaScript runtime
  deno                   # Secure JavaScript/TypeScript runtime

  # Python
  uv                     # Ultra-fast Python package installer
  poetry                 # Python dependency management
  pipenv                 # Python virtual environments

  # Others
  cargo                  # Rust package manager (comes with rustc)
];
```

### AI/LLM CLI Tools (❌ Not in nixpkgs - use language package managers)

```bash
# After applying home-manager configuration with cli-tools profile

# Claude Code (Anthropic)
npm install -g @anthropics/claude-code

# OpenAI Codex
npm install -g codex-cli

# Google Gemini
pip install --user google-generativeai

# Anthropic SDK
pip install --user anthropic

# GitHub Copilot CLI
npm install -g @githubnext/github-copilot-cli
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
