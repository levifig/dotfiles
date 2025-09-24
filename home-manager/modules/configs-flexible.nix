# Example: Flexible configuration management
# This shows how to keep configs editable while managing them with Nix

{ config, pkgs, lib, ... }:

{
  # Option 1: Link to existing config files (most flexible)
  # You can edit these directly in ~/.config/
  xdg.configFile = {
    # Link entire directories
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nvim";
      recursive = true;
    };

    # Link specific files
    "starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/starship.toml";
    };
  };

  # Option 2: Copy files (managed by Nix but less flexible)
  # Changes require rebuilding
  xdg.configFile."alacritty/themes" = {
    source = ./config-files/alacritty-themes;
    recursive = true;
  };

  # Option 3: Hybrid - Nix config with file imports
  programs.zsh = {
    enable = true;

    # Nix-managed settings
    history.size = 100000;

    # Import existing config files
    initExtra = ''
      # Load your existing zsh config
      [[ -f ~/.config/zsh/custom.zsh ]] && source ~/.config/zsh/custom.zsh

      # Load work-specific config if it exists
      [[ -f ~/.zshrc.work ]] && source ~/.zshrc.work
    '';

    # Import existing aliases
    shellAliases = import ./config-files/aliases.nix;
  };

  # Option 4: Template approach
  # Generate config from template with variables
  xdg.configFile."git/config" = {
    text = ''
      [user]
        name = ${config.programs.git.userName}
        email = ${config.programs.git.userEmail}

      # Rest of git config
      [include]
        path = ~/.config/git/local.conf  # Local overrides
    '';
  };

  # Option 5: Conditional management
  # Only manage if file doesn't exist
  xdg.configFile."tmux/tmux.conf" = lib.mkIf (!builtins.pathExists "${config.home.homeDirectory}/.config/tmux/tmux.conf") {
    source = ./config-files/tmux.conf;
  };
}