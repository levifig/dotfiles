{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    userName = "Levi Figueira";
    userEmail = "me@levifig.com";

    aliases = {
      l = "log --oneline";
      lg = "log --oneline --graph --decorate";
      wtf = "reflog";
      rs = "remote show origin";
    };

    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      ".unicorn*"
      ".ruby-gemset"
      ".vscode"
      "node_modules"
      "**/.claude/settings.local.json"
    ];

    extraConfig = {
      core = {
        editor = "nvim";
        pager = "delta";
        trustctime = false;
        autocrlf = "input";
      };

      init = {
        defaultBranch = "master";
      };

      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = true;
      };

      fetch = {
        prune = true;
      };

      branch = {
        autosetuprebase = "always";
      };

      credential = {
        helper = "osxkeychain";
      };

      apply = {
        whitespace = "nowarn";
      };

      pull = {
        default = "current";
        rebase = true;
      };

      push = {
        default = "current";
        autoSetupRemote = true;
      };

      rebase = {
        autostash = true;
      };

      difftool = {
        prompt = false;
        keepBackup = true;
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        navigate = true;
        dark = true;
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      mergetool = {
        prompt = false;
      };

      "filter \"media\"" = {
        clean = "git media clean %f";
        smudge = "git media smudge %f";
        required = true;
      };

      "filter \"lfs\"" = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      gpg = {
        format = "ssh";
      };

      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT8O1BCE6d5mjzD+k4VLeCyM5hjZ2kWnAr+p7XlMsmy";
      };
    };
  };
}
