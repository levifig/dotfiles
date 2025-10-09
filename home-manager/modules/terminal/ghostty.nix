{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    # Available in nixpkgs for both macOS and Linux
    package = pkgs.ghostty;

    settings = {
      # Font configuration
      font-family = "PragmataPro Liga";
      font-size = 18;

      # Theme
      theme = "Ayu Mirage";

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;

      # Behavior
      clipboard-trim-trailing-spaces = true;
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      link-url = true;

      # macOS specific
      macos-titlebar-style = "transparent";

      # Appearance
      background-opacity = 0.95;
      background-blur = 40;

      # Quick terminal
      quick-terminal-animation-duration = 0;

      # Window settings
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      window-theme = "system";
      window-padding-x = 15;
      window-padding-color = "extend";
      window-padding-balance = false;
      window-save-state = "always";

      # Keybindings
      keybind = [
        "global:shift+ctrl+opt+cmd+grave_accent=toggle_quick_terminal"
        "shift+enter=text:\\x1b\\r"
      ];
    };
  };
}
