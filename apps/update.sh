#!/usr/bin/env bash
# Update flake.lock and optionally rebuild
# Keeps your system up to date with latest packages

set -e

echo "🔄 Updating flake inputs..."

# Show what will be updated
echo ""
echo "Current flake inputs:"
nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.key != "root") | "\(.key): \(.value.locked.rev // .value.locked.narHash // "N/A" | .[0:8])"' 2>/dev/null || nix flake metadata
echo ""

# Update flake.lock
if nix flake update; then
  echo "✅ Flake inputs updated successfully!"
else
  echo "❌ Update failed!"
  exit 1
fi

echo ""
echo "Updated flake inputs:"
nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.key != "root") | "\(.key): \(.value.locked.rev // .value.locked.narHash // "N/A" | .[0:8])"' 2>/dev/null || nix flake metadata
echo ""

# Ask if user wants to rebuild
read -p "🤔 Rebuild and switch to new inputs? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  exec "$(dirname "$0")/switch.sh"
else
  echo "💡 Run 'nix run .#switch' when ready to apply updates"
fi
