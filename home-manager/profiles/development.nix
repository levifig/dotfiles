{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/ruby/gemrc.nix
    ../modules/javascript/eslintrc.nix
  ];

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
    golangci-lint

    # Rust
    rustc
    cargo
    rustfmt
    clippy

    # Nix
    nil  # Nix language server

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
    # Note: Terraform is provided by platform.nix profile

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
    # postman  # Requires building from source
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
    # ngrok  # Requires building from source
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

    # Note: Terraform aliases provided by platform.nix profile

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