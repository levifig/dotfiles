{ config, pkgs, lib, ... }:

let
  # Dynamically determine Ruby version from the package
  # Ruby's version attribute is a set with majMin (e.g., "3.4")
  rubyMajorMinor = pkgs.ruby.version.majMin or "3.4";
in
{
  # CLI tools installed via language-specific package managers
  # These are managed outside of Nix but with Nix-provided runtimes

  home.packages = with pkgs; [
    # AI/LLM CLI tools (not in nixpkgs)
    # Install these manually using the commands below:
    # - Claude Code: npm install -g @anthropics/claude-code
    # - Codex: npm install -g @openai/codex-cli
    # - OpenCode: npm install -g opencode
    # - Gemini CLI: pip install --user google-generativeai
  ];

  # Configure npm to use a home-managed prefix
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  # Add language package manager prefixes to PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"                 # npm global packages
    "${config.home.homeDirectory}/.local/bin"                      # pip --user packages
    "${config.home.homeDirectory}/.cargo/bin"                      # cargo install
    "${config.home.homeDirectory}/.gem/ruby/${rubyMajorMinor}.0/bin"  # gem install --user-install (dynamic version)
  ];

  # Create npm prefix directory
  home.file.".npm-global/.keep".text = "";

  # Configure npm and pip for user-local installs
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  programs.zsh.initContent = lib.mkAfter ''
    # Helper functions for managing global packages
    npm-list() {
      npm list -g --depth=0
    }

    pip-list-user() {
      pip list --user
    }

    gem-list-user() {
      gem list --user-install
    }
  '';
}
