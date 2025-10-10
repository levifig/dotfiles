{ config, lib, pkgs, ... }:
{
  # Deploy documentation
  xdg.configFile."opencode/OPENCODE.md" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/OPENCODE.md) {
    source = ../../../config/opencode/OPENCODE.md;
  };

  xdg.configFile."opencode/README.md" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/README.md) {
    source = ../../../config/opencode/README.md;
  };

  # Deploy opencode.json template (user fills in API keys)
  xdg.configFile."opencode/opencode.json.template" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/opencode.json.template) {
    source = ../../../config/opencode/opencode.json.template;
  };

  # Setup opencode.json with 1Password integration if available
  home.activation.initOpenCodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/opencode/opencode.json" ] && [ -f "$HOME/.config/opencode/opencode.json.template" ]; then
      # Try 1Password CLI first
      if command -v op &> /dev/null && op account get &> /dev/null; then
        # Try to read full config from 1Password
        if op read "op://Personal/OpenCode/config.json" &> /dev/null 2>&1; then
          $DRY_RUN_CMD op read "op://Personal/OpenCode/config.json" > "$HOME/.config/opencode/opencode.json" || true
          echo "✓ Created opencode.json from 1Password"
        else
          # Try to inject Context7 API key into template
          $DRY_RUN_CMD cp $VERBOSE_ARG \
            $HOME/.config/opencode/opencode.json.template \
            $HOME/.config/opencode/opencode.json

          if op read "op://Personal/Context7 API/credential" &> /dev/null 2>&1; then
            CONTEXT7_KEY=$(op read "op://Personal/Context7 API/credential" 2>/dev/null || echo "")
            if [ -n "$CONTEXT7_KEY" ]; then
              sed -i.bak "s/YOUR_CONTEXT7_API_KEY_HERE/$CONTEXT7_KEY/" "$HOME/.config/opencode/opencode.json" 2>/dev/null || true
              rm -f "$HOME/.config/opencode/opencode.json.bak"
              echo "✓ Created opencode.json with Context7 key from 1Password"
            else
              echo "⚠️  Created opencode.json from template. Run: ~/.dotfiles/scripts/setup-secrets.sh"
            fi
          else
            echo "⚠️  Created opencode.json from template. Run: ~/.dotfiles/scripts/setup-secrets.sh"
          fi
        fi
      else
        # No 1Password CLI, use template
        $DRY_RUN_CMD cp $VERBOSE_ARG \
          $HOME/.config/opencode/opencode.json.template \
          $HOME/.config/opencode/opencode.json
        echo "⚠️  Created opencode.json from template. Please edit to add your API keys."
        echo "   Or run: ~/.dotfiles/scripts/setup-secrets.sh (requires 1Password CLI)"
      fi
    fi
  '';

  # Deploy agent directory
  xdg.configFile."opencode/agent" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/agent) {
    source = ../../../config/opencode/agent;
    recursive = true;
  };

  # Deploy command directory
  xdg.configFile."opencode/command" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/command) {
    source = ../../../config/opencode/command;
    recursive = true;
  };

  # Deploy themes directory
  xdg.configFile."opencode/themes" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/themes) {
    source = ../../../config/opencode/themes;
    recursive = true;
  };

  # Deploy tool directory
  xdg.configFile."opencode/tool" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/tool) {
    source = ../../../config/opencode/tool;
    recursive = true;
  };

  # Deploy plugin directory
  xdg.configFile."opencode/plugin" = lib.mkIf
    (builtins.pathExists ../../../config/opencode/plugin) {
    source = ../../../config/opencode/plugin;
    recursive = true;
  };
}
