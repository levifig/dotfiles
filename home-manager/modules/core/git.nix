{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    # User info will be overridden in host-specific configs
    userName = lib.mkDefault "Levi Figueira";
    userEmail = lib.mkDefault "levi@levifig.com";

    # Core settings
    extraConfig = {
      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      push = {
        default = "current";
        autoSetupRemote = true;
      };

      fetch.prune = true;

      merge = {
        conflictstyle = "diff3";
        tool = "vimdiff";
      };

      diff = {
        colorMoved = "default";
        tool = "vimdiff";
      };

      rerere.enabled = true;

      # Better diffs
      diff.algorithm = "histogram";

      # URLs
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
        "git@gitlab.com:" = {
          insteadOf = "gl:";
        };
      };

      # Colors
      color = {
        ui = "auto";
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
    };

    # Aliases
    aliases = {
      # Status
      s = "status -s";
      st = "status";

      # Commit
      c = "commit";
      cm = "commit -m";
      ca = "commit -a";
      cam = "commit -am";
      amend = "commit --amend";

      # Branch
      b = "branch";
      ba = "branch -a";
      bd = "branch -d";
      bD = "branch -D";
      co = "checkout";
      cob = "checkout -b";

      # Diff
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";

      # Log
      l = "log --oneline --graph --decorate";
      ll = "log --oneline --graph --decorate --all";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

      # Push/Pull
      p = "push";
      pl = "pull";
      plo = "pull origin";
      plu = "pull upstream";
      po = "push origin";
      pu = "push upstream";

      # Remote
      r = "remote";
      rv = "remote -v";

      # Reset
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD~1";

      # Stash
      ss = "stash save";
      sp = "stash pop";
      sl = "stash list";

      # Utils
      aliases = "config --get-regexp alias";
      ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";

      # Cleanup
      cleanup = "!git branch --merged | grep -v '\\*\\|master\\|main\\|develop' | xargs -n 1 git branch -d";
    };

    # Global ignores
    ignores = [
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
      ".idea"
      ".vscode"
      "*.iml"
      ".env"
      ".direnv"
      "result"
      "result-*"
    ];

    # Enable delta for better diffs
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = false;
      };
    };

    # Enable git LFS
    lfs.enable = true;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
    };
  };

  # Lazygit
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
      os = {
        editCommand = "nvim";
      };
    };
  };
}