#!/usr/bin/env bash
# Rollback to previous generation
# Quickly revert problematic changes

set -e

echo "⏪ Rolling back to previous generation..."

# Determine if this is a darwin, nixos, or home-manager system
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Rolling back darwin configuration..."

  # List last 3 generations for context
  echo ""
  echo "Recent generations:"
  darwin-rebuild --list-generations | tail -3
  echo ""

  if darwin-rebuild rollback; then
    echo "✅ Rolled back successfully!"
    echo "🎉 Current generation: $(darwin-rebuild --list-generations | tail -1)"
  else
    echo "❌ Rollback failed!"
    exit 1
  fi
elif [[ -f /etc/NIXOS ]]; then
  echo "🐧 Rolling back NixOS configuration..."

  # List last 3 generations for context
  echo ""
  echo "Recent generations:"
  nixos-rebuild list-generations | tail -3
  echo ""

  if sudo nixos-rebuild switch --rollback; then
    echo "✅ Rolled back successfully!"
    echo "🎉 Current generation: $(nixos-rebuild list-generations | tail -1)"
  else
    echo "❌ Rollback failed!"
    exit 1
  fi
else
  echo "🏠 Rolling back Home Manager configuration..."

  # List last 3 generations for context
  echo ""
  echo "Recent generations:"
  home-manager generations | head -3
  echo ""

  if home-manager rollback; then
    echo "✅ Rolled back successfully!"
  else
    echo "❌ Rollback failed!"
    exit 1
  fi
fi

echo ""
echo "💡 Tip: Run 'nix run .#switch' to go forward again"
