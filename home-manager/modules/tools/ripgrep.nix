{ config, lib, ... }:

{
  # Ripgrep configuration
  xdg.configFile."ripgrep/config".text = ''
    # Ripgrep configuration
    # https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file

    # Search hidden files/directories (e.g., dotfiles)
    --hidden

    # Follow symbolic links
    --follow

    # Smart case: case-insensitive if pattern is all lowercase, case-sensitive otherwise
    --smart-case

    # Show line numbers
    --line-number

    # Ignore files/directories
    --glob=!.git/
    --glob=!node_modules/
    --glob=!.cache/
    --glob=!.npm/
    --glob=!.nix-profile/
    --glob=!.nix-defexpr/
    --glob=!Library/
    --glob=!.local/share/
    --glob=!.local/state/
    --glob=!*.pyc
    --glob=!*.min.js
    --glob=!*.min.css
    --glob=!dist/
    --glob=!build/
    --glob=!target/
    --glob=!vendor/
  '';
}
