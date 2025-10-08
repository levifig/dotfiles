{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;

    # Enable integration with shells
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      # General format
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$git_state"
        "$nix_shell"
        "$nodejs"
        "$ruby"
        "$python"
        "$golang"
        "$rust"
        "$terraform"
        "$docker_context"
        "$kubernetes"
        "$aws"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      # Prompt character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold yellow)";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold cyan";
        read_only = " 🔒";
        read_only_style = "red";
        truncation_symbol = "…/";
      };

      # Git
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "⚔️ ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "🤷\${count}";
        stashed = "📦\${count}";
        modified = "📝\${count}";
        staged = "➕\${count}";
        renamed = "✏️ \${count}";
        deleted = "🗑️ \${count}";
      };

      # Username
      username = {
        style_user = "bold yellow";
        style_root = "bold red";
        format = "[$user]($style) ";
        disabled = false;
        show_always = false;
      };

      # Hostname
      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) ";
        style = "bold green";
      };

      # Nix shell
      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄️ ";
        style = "bold blue";
      };

      # Languages
      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold green";
        detect_extensions = [ "js" "mjs" "cjs" "ts" "tsx" ];
        detect_files = [ "package.json" ".node-version" ".nvmrc" ];
      };

      python = {
        format = "[$symbol($version )($virtualenv )]($style)";
        symbol = "🐍 ";
        style = "bold yellow";
        detect_extensions = [ "py" ];
        detect_files = [ "requirements.txt" "pyproject.toml" "Pipfile" ];
      };

      ruby = {
        format = "[$symbol($version )]($style)";
        symbol = "💎 ";
        style = "bold red";
        detect_extensions = [ "rb" ];
        detect_files = [ "Gemfile" ".ruby-version" ];
      };

      golang = {
        format = "[$symbol($version )]($style)";
        symbol = "🐹 ";
        style = "bold cyan";
        detect_extensions = [ "go" ];
        detect_files = [ "go.mod" "go.sum" ];
      };

      rust = {
        format = "[$symbol($version )]($style)";
        symbol = "🦀 ";
        style = "bold red";
        detect_extensions = [ "rs" ];
        detect_files = [ "Cargo.toml" ];
      };

      # Tools
      terraform = {
        format = "[$symbol$workspace]($style) ";
        symbol = "💠 ";
        style = "bold purple";
      };

      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = "🐋 ";
        style = "bold blue";
        disabled = false;
      };

      kubernetes = {
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        symbol = "☸ ";
        style = "bold cyan";
        disabled = false;
      };

      aws = {
        format = "[$symbol($profile )(\\($region\\) )]($style)";
        symbol = "☁️ ";
        style = "bold yellow";
      };

      # Command duration
      cmd_duration = {
        min_time = 2000; # Show duration for commands longer than 2s
        format = "[$duration]($style) ";
        style = "bold yellow";
      };

      # Time (disabled by default)
      time = {
        disabled = true;
        format = "[$time]($style) ";
        style = "bold white";
      };
    };
  };
}