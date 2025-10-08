#!/usr/bin/env bash
# Build and activate configuration
# Enhanced version with better detection and feedback

set -e

echo "🔄 Switching configuration..."

# Detect hostname
HOST=$(hostname -s)
CONFIG="${HOST}"

# Determine if this is a darwin, nixos, or home-manager system
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Switching darwin configuration for: $CONFIG"

  if darwin-rebuild switch --flake ".#$CONFIG"; then
    echo "✅ Darwin configuration activated successfully!"
    echo "🎉 System generation: $(darwin-rebuild --list-generations | tail -1)"
  else
    echo "❌ Switch failed!"
    exit 1
  fi
elif [[ -f /etc/NIXOS ]]; then
  echo "🐧 Switching NixOS configuration for: $CONFIG"

  if sudo nixos-rebuild switch --flake ".#$CONFIG"; then
    echo "✅ NixOS configuration activated successfully!"
    echo "🎉 System generation: $(nixos-rebuild list-generations | tail -1)"
  else
    echo "❌ Switch failed!"
    exit 1
  fi
else
  echo "🏠 Switching Home Manager configuration for: levifig@$CONFIG"

  if home-manager switch --flake ".#levifig@$CONFIG" 2>/dev/null; then
    echo "✅ Home Manager configuration activated successfully!"
  elif home-manager switch --flake ".#levifig" 2>/dev/null; then
    echo "ℹ️  No specific config for $HOST, using default"
    echo "✅ Home Manager configuration activated successfully!"
  else
    echo "❌ Switch failed!"
    exit 1
  fi
fi

echo ""
echo "💡 Tip: Run 'nix run .#rollback' to revert if needed"
