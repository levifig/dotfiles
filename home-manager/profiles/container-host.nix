{ config, pkgs, lib, ... }:

{
  # Container Host Profile
  # Optimized configuration for machines running Docker/Podman containers
  #
  # This is an example of using profiles as "templates" for deployment patterns.
  # Import this profile in minimal host files for standardized container host setups.
  #
  # Usage in a host file:
  #   imports = [
  #     ../profiles/container-host.nix
  #     ../profiles/monitoring.nix  # Profiles can be composed!
  #   ];

  # Essential container and orchestration tools
  home.packages = with pkgs; [
    # Container runtimes & tools
    docker-compose
    lazydocker  # TUI for docker
    dive        # Docker image explorer

    # Kubernetes tools (if needed)
    kubectl
    k9s         # TUI for kubernetes
    helm

    # Container security & scanning
    trivy       # Vulnerability scanner

    # Registry tools
    skopeo      # Work with remote container registries

    # Debugging & utilities
    ctop        # Top-like interface for containers

    # Infrastructure as Code
    terraform
    ansible
  ];

  # Container-specific shell aliases
  home.shellAliases = {
    # Docker shortcuts
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    dpsa = "docker ps -a";
    di = "docker images";
    dex = "docker exec -it";
    dlogs = "docker logs -f";
    dprune = "docker system prune -af --volumes";

    # Kubernetes shortcuts
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kdesc = "kubectl describe";
    klogs = "kubectl logs -f";
  };

  # Git configuration for container/infrastructure work
  programs.git = {
    # Ensure git is configured (inherits from core git module)
    # Add any container-host specific git config here
  };

  # Tmux configuration optimized for container management
  programs.tmux = {
    # Enable mouse mode for easier container log scrolling
    extraConfig = ''
      # Container host specific tmux settings
      set -g mouse on

      # Larger scrollback for container logs
      set -g history-limit 50000
    '';
  };

  # Environment variables for container work
  home.sessionVariables = {
    # Docker buildkit
    DOCKER_BUILDKIT = "1";

    # Compose v2
    COMPOSE_DOCKER_CLI_BUILD = "1";
  };

  # Note: Docker daemon itself should be managed at the system level
  # For NixOS: virtualisation.docker.enable = true;
  # For macOS: Install Docker Desktop via homebrew cask (see darwin/modules/homebrew.nix)
}
