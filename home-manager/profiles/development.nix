{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Version control
    git-lfs
    git-crypt
    git-filter-repo
    tig

    # Build tools
    cmake
    ninja
    meson
    autoconf
    automake
    libtool
    pkg-config

    # Language-specific tools
    # Ruby
    ruby_3_4
    rubyPackages_3_4.solargraph

    # Python
    python313
    python313Packages.pip
    python313Packages.virtualenv
    poetry
    pipenv

    # Node.js
    nodejs_24
    nodePackages.pnpm
    nodePackages.yarn
    nodePackages.typescript
    nodePackages.eslint

    # Go
    go
    gopls
    gotools
    golangci-lint

    # Rust
    rustc
    cargo
    rustfmt
    clippy

    # Containers
    docker-client
    docker-compose
    podman
    # buildah  # Build failure on macOS
    skopeo

    # Cloud tools
    awscli2
    google-cloud-sdk
    azure-cli
    (terraform.withPlugins (p: with p; [
      aws
      google
      azurerm
      kubernetes
    ]))
    # terraform-docs  # Build failure in current nixpkgs
    tflint
    terragrunt

    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
    helmfile
    kustomize
    k9s
    stern
    kubeval
    kubeconform

    # Database tools
    postgresql
    mariadb
    redis
    sqlite

    # API tools
    curl
    httpie
    wget
    postman
    grpcurl

    # Debugging/Profiling
    gdb
    lldb
    # perf-tools  # Linux-only
    hyperfine
    tokei

    # Documentation
    mdbook
    pandoc
    graphviz

    # CI/CD
    gh
    # gitlab  # Linux-only
    act  # Run GitHub Actions locally

    # Development utilities
    direnv
    watchman
    entr
    just
    mkcert
    ngrok
  ];

  # Development-specific shell aliases
  home.shellAliases = {
    # Docker
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    di = "docker images";

    # Kubernetes
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
    kg = "kubectl get";
    kd = "kubectl describe";
    kl = "kubectl logs";
    ke = "kubectl exec -it";

    # Terraform
    tf = "terraform";
    tfi = "terraform init";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfd = "terraform destroy";

    # Git shortcuts
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log";
    gd = "git diff";
  };

  # Enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Configure language-specific environments
  programs.go.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };
}