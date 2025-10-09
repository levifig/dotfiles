{ config, pkgs, lib, ... }:

{
  # Atuin - magical shell history
  # https://github.com/atuinsh/atuin

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Disable up-arrow binding to preserve default zsh behavior
    flags = [ "--disable-up-arrow" ];

    settings = {
      # Execute command immediately on enter (tab to edit)
      enter_accept = true;

      # Search settings
      search_mode = "fuzzy";
      filter_mode = "global";

      # UI preferences
      style = "auto";
      show_preview = false;

      # Sync settings (adjust if using atuin sync)
      auto_sync = true;
      sync_frequency = "10m";

      # Security - filter secrets from history
      secrets_filter = true;

      # Keymap mode
      keymap_mode = "auto";
    };
  };
}
