{ config, pkgs, lib, ... }:

{
  # Workstation Headless profile - Full development environment without GUI
  # Builds on server.nix, adds all CLI development tools
  # Perfect for remote workstations, SSH sessions, or headless systems

  imports = [
    ./server.nix  # Inherit all server tools
    ./development.nix  # Development tools and language runtimes
    ../modules/shell/zsh.nix
    ../modules/editors/nvim.nix
    ../modules/terminal/tmux.nix
    ../modules/terminal/starship.nix
  ];

  home.packages = with pkgs; [
    # Upgrade to better alternatives
    # Note: neovim is configured via modules/editors/nvim.nix
    bat         # Better cat
    eza         # Better ls
    fd          # Better find
    zoxide      # Smart cd

    # Shell enhancements
    fzf
    atuin
    starship
    # Note: direnv is provided by development.nix

    # Development tools - Version management
    # Note: Language runtimes (node, ruby, python, go) are provided by development.nix
    # Only include tools not in development.nix here
    bun
    uv

    # Note: Build tools and language toolchains are provided by development.nix

    # Container tools (basic docker, k8s/cloud tools from platform.nix)
    docker-client
    docker-compose
    lazydocker

    # Note: Kubernetes, IaC, and Cloud tools are provided by platform.nix profile
    # Note: Database tools are provided by development.nix profile
    # Note: Git tools (gh, delta, etc.) are provided by development.nix profile

    # Utilities specific to workstation-headless
    jump
    just
    tokei
    hyperfine

    # Fun utilities
    cowsay
    fortune
  ];

  # Enhanced shell aliases
  home.shellAliases = lib.mkMerge [
    # Inherit server aliases, then add more
    {
      # Modern replacements
      cat = "bat";
      ls = "eza";
      find = "fd";
      grep = "rg";

      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log";
      gd = "git diff";

      # Docker shortcuts
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      di = "docker images";

      # Kubernetes shortcuts
      k = "kubectl";
      kx = "kubectx";
      kg = "kubectl get";
      kd = "kubectl describe";
      kl = "kubectl logs";

      # Terraform shortcuts
      tf = "terraform";
      tfi = "terraform init";
      tfp = "terraform plan";
      tfa = "terraform apply";
    }
  ];

  # Development environment variables
  home.sessionVariables = {
    EDITOR = lib.mkForce "nvim";  # Override server.nix vim setting
    VISUAL = lib.mkForce "nvim";

    # Language-specific
    GOPATH = "${config.home.homeDirectory}/go";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";

    # Cloud
    AWS_PAGER = "";  # Disable AWS CLI pager
  };

  # Note: direnv and language-specific programs are configured in development.nix
}
