#!/usr/bin/env bash
# Build configuration without activating
# Useful for testing changes before switching

set -e

echo "🔨 Building configuration..."

# Detect hostname
HOST=$(hostname -s)
CONFIG="${HOST}"

# Determine if this is a darwin or nixos system
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Building darwin configuration for: $CONFIG"

  if darwin-rebuild build --flake ".#$CONFIG" 2>/dev/null; then
    echo "✅ Build successful!"
    echo "💡 Run 'nix run .#switch' to activate"
  else
    echo "❌ Build failed!"
    exit 1
  fi
elif [[ -f /etc/NIXOS ]]; then
  echo "📦 Building NixOS configuration for: $CONFIG"

  if nixos-rebuild build --flake ".#$CONFIG" 2>/dev/null; then
    echo "✅ Build successful!"
    echo "💡 Run 'nix run .#switch' to activate"
  else
    echo "❌ Build failed!"
    exit 1
  fi
else
  echo "📦 Building Home Manager configuration for: levifig@$CONFIG"

  if home-manager build --flake ".#levifig@$CONFIG" 2>/dev/null; then
    echo "✅ Build successful!"
    echo "💡 Run 'nix run .#switch' to activate"
  else
    echo "❌ Build failed!"
    exit 1
  fi
fi
