#!/usr/bin/env bash
# Garbage collect old Nix generations and store paths
# Frees up disk space by removing unused packages

set -e

echo "🧹 Cleaning up Nix store..."

# Show current disk usage
echo ""
echo "Current Nix store size:"
du -sh /nix/store 2>/dev/null || echo "Unable to determine store size"
echo ""

# Parse arguments for age
AGE=${1:-30}  # Default to 30 days

echo "🗑️  Removing generations older than ${AGE} days..."

# Determine if this is a darwin, nixos, or home-manager system
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Cleaning darwin generations..."

  # Show generations that will be deleted
  echo ""
  echo "Generations to be deleted:"
  darwin-rebuild --list-generations | head -n -3 || true
  echo ""

  # Delete old generations
  nix-env --delete-generations "${AGE}d" -p /nix/var/nix/profiles/system 2>/dev/null || true
elif [[ -f /etc/NIXOS ]]; then
  echo "🐧 Cleaning NixOS generations..."

  # Show generations that will be deleted
  echo ""
  echo "Generations to be deleted:"
  nixos-rebuild list-generations | head -n -3 || true
  echo ""

  # Delete old generations (requires sudo)
  sudo nix-env --delete-generations "${AGE}d" -p /nix/var/nix/profiles/system
else
  echo "🏠 Cleaning Home Manager generations..."

  # Delete old home-manager generations
  home-manager expire-generations "-${AGE} days" 2>/dev/null || true
fi

# Clean up user profile
echo ""
echo "🧹 Cleaning user profile..."
nix-env --delete-generations "${AGE}d" 2>/dev/null || true

# Run garbage collection
echo ""
echo "🗑️  Running garbage collection..."
if [[ -f /etc/NIXOS ]]; then
  sudo nix-collect-garbage -d
else
  nix-collect-garbage -d
fi

# Optimize store
echo ""
echo "⚡ Optimizing store..."
if [[ -f /etc/NIXOS ]]; then
  sudo nix-store --optimise
else
  nix-store --optimise
fi

# Show new disk usage
echo ""
echo "✅ Cleanup complete!"
echo ""
echo "New Nix store size:"
du -sh /nix/store 2>/dev/null || echo "Unable to determine store size"

echo ""
echo "💡 Tip: Run 'nix run .#clean -- 60' to clean generations older than 60 days"
