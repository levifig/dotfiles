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

  # Copy template to opencode.json on first run (user can modify after)
  home.activation.initOpenCodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/opencode/opencode.json" ] && [ -f "$HOME/.config/opencode/opencode.json.template" ]; then
      $DRY_RUN_CMD cp $VERBOSE_ARG \
        $HOME/.config/opencode/opencode.json.template \
        $HOME/.config/opencode/opencode.json
      echo "⚠️  Created opencode.json from template. Please edit to add your API keys."
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
