# Managing Project-Specific Versions

You asked: "Do I still need mise? How else can I use specific versions on a per project basis?"

## TL;DR

**You have 3 options:**

1. **Keep mise** (easiest migration, familiar workflow)
2. **Use direnv + Nix** (pure Nix, best for reproducibility)
3. **Hybrid** (Nix globally, mise for projects)

## Option 1: Keep mise (Recommended During Migration)

**How it works:**
```bash
# In your project
echo "python 3.11.0" > .tool-versions
mise install
# mise automatically activates when you cd into the directory
```

**Pros:**
- ✅ You already know it
- ✅ Works with existing `.tool-versions` files
- ✅ Compatible with asdf/rtx ecosystems
- ✅ Fast project switching

**Cons:**
- ❌ Not pure Nix (downloads external binaries)
- ❌ Less reproducible than Nix flakes

**Setup:** Already in homebrew.nix as "mise" (commented out). Uncomment it.

---

## Option 2: direnv + Nix Flakes (Pure Nix Way)

**How it works:**
```nix
# Create flake.nix in your project
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-darwin.default = nixpkgs.legacyPackages.x86_64-darwin.mkShell {
      buildInputs = [
        nixpkgs.python311  # Specific Python version
        nixpkgs.nodejs_18  # Specific Node version
      ];
    };
  };
}
```

```bash
# Create .envrc in your project
use flake
```

```bash
# Install direnv (already available via Nix)
# Auto-activates when you cd into directory
```

**Pros:**
- ✅ Pure Nix (100% reproducible)
- ✅ Lock file (flake.lock) ensures exact versions
- ✅ Can specify ANY package version from nixpkgs history
- ✅ Share dev environments with team
- ✅ Works across all Nix platforms

**Cons:**
- ❌ Learning curve (need to write flake.nix)
- ❌ Not compatible with .tool-versions
- ❌ Requires existing projects to be migrated

**Setup:** Already have direnv in your config. Just create flake.nix per project.

---

## Option 3: Hybrid Approach

Use Nix for global defaults, mise for project overrides:

```bash
# Global Python 3.13 via Nix (in your devShell)
nix develop ~/.dotfiles#python

# Project needs Python 3.11? Use mise
cd ~/Work/legacy-project
echo "python 3.11.0" > .tool-versions
mise install
# mise's Python 3.11 shadows Nix's Python 3.13 in this directory
```

**Pros:**
- ✅ Best of both worlds
- ✅ Gradual migration path
- ✅ Nix for new projects, mise for legacy

**Cons:**
- ❌ Two systems to maintain
- ❌ Can be confusing which is active

---

## Comparison Table

| Feature | mise | direnv + Nix | Hybrid |
|---------|------|-------------|--------|
| Learning Curve | Easy | Medium | Medium |
| Reproducibility | Good | Excellent | Good |
| Speed | Fast | Fast | Fast |
| Team Sharing | .tool-versions | flake.nix | Both |
| Migration Effort | None | High | Low |
| Pure Nix | ❌ | ✅ | Partial |

---

## My Recommendation

**Phase 1 (Now):** Keep mise
- Uncomment `"mise"` in homebrew.nix
- Continue using .tool-versions
- Zero disruption to workflow

**Phase 2 (Later):** Migrate projects gradually
- New projects: Use direnv + Nix flakes (see your devShells in flake.nix as examples)
- Existing projects: Keep using mise until you have time to migrate

**Phase 3 (Optional):** Drop mise
- Once all projects have flake.nix
- Remove mise from homebrew.nix

---

## Quick Start Examples

### Using direnv + Nix (Recommended for new projects)

```bash
# Create new project
mkdir my-project && cd my-project

# Create flake.nix
cat > flake.nix <<EOF
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
      buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [
        python311
        nodejs_20
        postgresql_14
      ];
    };
  };
}
EOF

# Create .envrc
echo "use flake" > .envrc
direnv allow

# Now python, node, psql are available in this directory only!
python --version  # 3.11.x
```

### Using mise (Familiar workflow)

```bash
cd my-legacy-project

# Create .tool-versions
cat > .tool-versions <<EOF
python 3.11.9
nodejs 18.20.0
ruby 3.2.2
EOF

# Install and activate
mise install
# Done! Versions automatically activate in this directory
```

---

## Bottom Line

**Keep mise for now** - it works, you know it, and migration can happen gradually. Your Nix config already supports direnv for when you're ready to migrate projects.
