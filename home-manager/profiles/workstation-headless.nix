{ config, pkgs, lib, ... }:

{
  # Workstation Headless profile - Full development environment without GUI
  # Builds on server.nix, adds all CLI development tools
  # Perfect for remote workstations, SSH sessions, or headless systems

  imports = [
    ./server.nix  # Inherit all server tools
  ];

  home.packages = with pkgs; [
    # Upgrade to better alternatives
    neovim      # Full neovim instead of basic vim
    bat         # Better cat
    eza         # Better ls
    fd          # Better find
    zoxide      # Smart cd

    # Shell enhancements
    fzf
    atuin
    direnv
    starship

    # Development tools - Version management
    nodejs_22
    ruby_3_4
    python313
    go_1_24
    bun
    uv

    # Development tools - Build systems
    cmake
    ninja
    meson
    autoconf
    automake
    libtool
    pkg-config

    # Development tools - Languages
    rustc
    cargo
    rustfmt
    clippy

    # Container tools
    docker-client
    docker-compose
    lazydocker

    # Kubernetes tools
    kubectl
    kubectx
    kubernetes-helm
    helmfile
    kustomize
    k9s
    stern
    argocd

    # Infrastructure as Code
    terraform
    terragrunt
    tflint
    ansible
    ansible-lint

    # Cloud CLIs
    awscli2
    google-cloud-sdk
    azure-cli

    # Database tools
    postgresql
    mariadb
    redis
    sqlite

    # API tools
    httpie
    grpcurl

    # Utilities
    gh
    git-delta
    git-filter-repo
    tig
    lazygit
    jump
    just
    tokei
    hyperfine
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
    EDITOR = "nvim";
    VISUAL = "nvim";

    # Language-specific
    GOPATH = "${config.home.homeDirectory}/go";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";

    # Kubernetes
    KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
    KUBE_EDITOR = "nvim";

    # Cloud
    AWS_PAGER = "";  # Disable AWS CLI pager
  };

  # Import full configuration modules
  imports = [
    ./server.nix  # Already included above, but making it explicit
    ../modules/shell/zsh.nix
    ../modules/editors/nvim.nix
    ../modules/terminal/tmux.nix
    ../modules/terminal/starship.nix
    ../modules/git/config.nix
  ];

  # Enable direnv for project-specific environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Enable language-specific programs
  programs.go.enable = true;
}
