{ config, pkgs, lib, ... }:

{
  # Work-specific configuration
  home.username = "levifig";
  home.homeDirectory = "/Users/levifig";

  # ============================================
  # 🔧 CUSTOMIZE: Your Work Git Identity
  # ============================================
  programs.git = {
    userName = "Levi Figueira";
    userEmail = "levi@work.com";  # Work email
    signing.key = "~/.ssh/work_id_ed25519.pub";  # Work SSH key
  };
  # ============================================

  # Work-specific packages
  home.packages = with pkgs; [
    # Communication
    slack
    zoom-us

    # Work-specific tools
    # Add company-specific tools here

    # VPN clients
    # openconnect
    # openvpn
  ];

  # Work-specific environment variables
  home.sessionVariables = {
    # Add work-specific environment variables
    # WORK_PROJECT_PATH = "$HOME/Work/Projects";
  };

  # Work-specific shell aliases
  home.shellAliases = {
    # Work VPN
    # vpnup = "sudo openconnect vpn.company.com";
    # vpndown = "sudo killall openconnect";

    # Work projects shortcuts
    work = "cd ~/Work";
    projects = "cd ~/Work/Projects";
  };

  # SSH config for work servers
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "work-*" = {
        user = "levifig";
        identityFile = "~/.ssh/work_id_ed25519";
        # Add other work-specific SSH settings
      };

      "gitlab.work.com" = {
        hostname = "gitlab.work.com";
        user = "git";
        identityFile = "~/.ssh/work_id_ed25519";
      };
    };
  };

  # Work-specific Git configuration
  programs.git.includes = [
    {
      condition = "gitdir:~/Work/";
      contents = {
        user = {
          email = "levi@work.com"; # Replace with actual work email
          signingKey = "~/.ssh/work_id_ed25519.pub";
        };
      };
    }
  ];

  # AWS profiles for work
  programs.awscli = {
    enable = true;
    settings = {
      "profile work-dev" = {
        region = "us-east-1";
        output = "json";
      };
      "profile work-staging" = {
        region = "us-east-1";
        output = "json";
      };
      "profile work-prod" = {
        region = "us-east-1";
        output = "json";
      };
    };
  };

  # Kubernetes contexts for work
  home.file.".kube/config.d/work.yaml" = {
    text = ''
      # Work Kubernetes clusters configuration
      # This would contain actual cluster configurations
    '';
  };

  # Custom scripts for work
  home.file.".local/bin/work-setup" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Script to set up work environment
      echo "Setting up work environment..."

      # Example: Set up AWS credentials
      # aws sso login --profile work-dev

      # Example: Connect to VPN
      # sudo openconnect vpn.work.com

      echo "Work environment ready!"
    '';
  };
}