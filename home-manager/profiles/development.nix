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
    # rubyPackages_3_4.solargraph  # Disabled: nokogiri dependency fails to build on macOS

    # Python
    python313
    python313Packages.pip
    python313Packages.virtualenv
    poetry
    pipenv
    uv                       # Fast Python package installer (Rust-based pip replacement)

    # JavaScript runtime
    bun                      # Fast all-in-one JavaScript runtime, package manager, and bundler
    # Note: Removed nodejs, pnpm, yarn - bun handles all JS/TS needs
    # Use `bun install`, `bun run`, `bunx` for package management
    # For projects requiring Node.js specifically, use direnv + flake.nix

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
    nixd  # Nix language server
    nil   # Alternative Nix language server

    # Containers
    docker-client
    docker-compose
    podman
    # buildah  # Build failure on macOS
    skopeo

    # Infrastructure as Code
    (terraform.withPlugins (p: with p; [
      aws
      google
      azurerm
      kubernetes
    ]))
    terragrunt
    # terraform-docs  # Build failure in current nixpkgs
    tflint
    checkov
    infracost

    # Configuration Management
    ansible
    ansible-lint

    # Cloud CLIs
    awscli2
    google-cloud-sdk
    azure-cli
    doctl  # DigitalOcean

    # Kubernetes & Container Orchestration
    kubectl
    krew  # kubectl plugin manager
    kubectx
    kubernetes-helm
    helmfile
    kustomize
    k9s
    stern
    kubeval
    kubeconform
    kubeseal
    linkerd
    fluxcd
    talosctl  # Talos Linux management

    # Service Mesh & Networking
    istioctl
    # consul  # Requires building from source
    # envoy is Linux-only

    # CI/CD Tools
    gh
    # gitlab  # Linux-only
    act  # Run GitHub Actions locally
    # jenkins  # Not available on aarch64-darwin
    argocd
    tektoncd-cli

    # Monitoring & Observability
    prometheus
    grafana-loki
    # promtool  # Not available as standalone package

    # Policy & Compliance
    # open-policy-agent  # Build failure in current nixpkgs
    conftest
    cosign
    syft
    grype

    # Secrets Management
    vault
    kubeseal  # Was: sealed-secrets-kubeseal
    sops
    age

    # Load Testing
    k6
    vegeta

    # Database tools
    postgresql
    mariadb
    redis
    sqlite
    # clickhouse  # Requires building from source
    apacheKafka

    # Networking Tools
    mtr
    nmap
    tcpdump
    wireshark-cli
    iperf3
    netcat

    # Cloud Native Tools
    pack  # Cloud Native Buildpacks
    skaffold
    tilt

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

    # Backup & Disaster Recovery
    velero
    restic

    # Documentation
    hugo
    mdbook
    pandoc
    graphviz

    # Utilities
    yq-go
    cue
    dhall
    vendir

    # Development utilities
    direnv
    watchman
    entr
    just
    mkcert
    # ngrok  # Requires building from source
  ];

  # Note: Shell aliases are centralized in modules/shell/aliases.nix

  # Environment variables
  home.sessionVariables = {
    # Kubernetes
    KUBECONFIG = "$HOME/.kube/config";
    KUBE_EDITOR = "nvim";

    # Helm
    HELM_HOME = "$HOME/.helm";

    # Terraform
    TF_CLI_ARGS_plan = "-parallelism=50";
    TF_CLI_ARGS_apply = "-parallelism=50";

    # Cloud
    AWS_PAGER = "";  # Disable AWS CLI pager
    CLOUDSDK_CORE_DISABLE_PROMPTS = "1";  # Disable GCP prompts
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

  # Additional Zsh configuration
  programs.zsh.initContent = lib.mkAfter ''
    # Kubernetes completion
    if command -v kubectl >/dev/null 2>&1; then
      source <(kubectl completion zsh)
    fi

    # Helm completion
    if command -v helm >/dev/null 2>&1; then
      source <(helm completion zsh)
    fi

    # ArgoCD completion
    if command -v argocd >/dev/null 2>&1; then
      source <(argocd completion zsh)
    fi

    # Terraform workspace in prompt
    tf_prompt_info() {
      if [ -d .terraform ]; then
        workspace=$(terraform workspace show 2>/dev/null)
        if [ $? -eq 0 ] && [ "$workspace" != "default" ]; then
          echo " (tf:$workspace)"
        fi
      fi
    }

    # Kubernetes context in prompt
    kube_prompt_info() {
      if command -v kubectl >/dev/null 2>&1; then
        context=$(kubectl config current-context 2>/dev/null)
        if [ $? -eq 0 ]; then
          echo " (k8s:$context)"
        fi
      fi
    }
  '';
}
