{ config, lib, pkgs, ... }:

{
  # Deploy themes as read-only
  xdg.configFile."zed/themes" = {
    source = ../../../config/zed/themes;
    recursive = true;
  };

  # Deploy keymap if it exists
  xdg.configFile."zed/keymap.json" = lib.mkIf
    (builtins.pathExists ../../../config/zed/keymap.json) {
    source = ../../../config/zed/keymap.json;
  };

  # Deploy settings template
  xdg.configFile."zed/settings.json.template" = lib.mkIf
    (builtins.pathExists ../../../config/zed/settings.json.template) {
    source = ../../../config/zed/settings.json.template;
  };

  # Copy template to settings.json on first run (user can modify after)
  home.activation.initZedConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/zed/settings.json" ] && [ -f "$HOME/.config/zed/settings.json.template" ]; then
      $DRY_RUN_CMD cp $VERBOSE_ARG \
        $HOME/.config/zed/settings.json.template \
        $HOME/.config/zed/settings.json
    fi
  '';
}
