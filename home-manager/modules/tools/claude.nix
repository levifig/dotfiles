{ config, lib, pkgs, ... }:
{
  # Deploy CLAUDE.md
  xdg.configFile."claude/CLAUDE.md" = lib.mkIf
    (builtins.pathExists ../../../config/claude/CLAUDE.md) {
    source = ../../../config/claude/CLAUDE.md;
  };

  # Deploy agents directory
  xdg.configFile."claude/agents" = lib.mkIf
    (builtins.pathExists ../../../config/claude/agents) {
    source = ../../../config/claude/agents;
    recursive = true;
  };

  # Deploy commands directory
  xdg.configFile."claude/commands" = lib.mkIf
    (builtins.pathExists ../../../config/claude/commands) {
    source = ../../../config/claude/commands;
    recursive = true;
  };

  # Deploy hooks directory
  xdg.configFile."claude/hooks" = lib.mkIf
    (builtins.pathExists ../../../config/claude/hooks) {
    source = ../../../config/claude/hooks;
    recursive = true;
  };

  # Deploy plugins directory
  xdg.configFile."claude/plugins" = lib.mkIf
    (builtins.pathExists ../../../config/claude/plugins) {
    source = ../../../config/claude/plugins;
    recursive = true;
  };

  # Deploy output-styles directory
  xdg.configFile."claude/output-styles" = lib.mkIf
    (builtins.pathExists ../../../config/claude/output-styles) {
    source = ../../../config/claude/output-styles;
    recursive = true;
  };
}
