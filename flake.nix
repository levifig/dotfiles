{
  description = "Levi's Nix + Home Manager Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin (macOS) support
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin, flake-utils, ... }@inputs:
    let
      # System types
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper function to generate system-specific outputs
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # User configuration
      user = "levifig";

      # Helper to determine if system is Darwin
      isDarwin = system: builtins.elem system [ "x86_64-darwin" "aarch64-darwin" ];

      # Get appropriate nixpkgs for system
      nixpkgsFor = system: if isDarwin system then nixpkgs-darwin else nixpkgs;
    in
    {
      # Home Manager Configurations
      homeConfigurations = {
        # Default configuration (auto-detected)
        "${user}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
          modules = [
            ./home-manager/home.nix
            {
              home = {
                username = user;
                homeDirectory = if isDarwin builtins.currentSystem
                  then "/Users/${user}"
                  else "/home/${user}";
              };
            }
          ];
        };

        # Work MacBook (Apple Silicon)
        "${user}@macbook-work" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-darwin.legacyPackages.aarch64-darwin;
          modules = [
            ./home-manager/home.nix
            ./home-manager/platform/darwin-base.nix
            ./home-manager/profiles/development.nix
            ./home-manager/profiles/platform.nix
            ./home-manager/hosts/macbook-work.nix
            {
              home = {
                username = user;
                homeDirectory = "/Users/${user}";
              };
            }
          ];
        };

        # Personal MacBook (Apple Silicon)
        "${user}@macbook-personal" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-darwin.legacyPackages.aarch64-darwin;
          modules = [
            ./home-manager/home.nix
            ./home-manager/platform/darwin-base.nix
            ./home-manager/profiles/development.nix
            ./home-manager/profiles/desktop.nix
            ./home-manager/hosts/macbook-personal.nix
            {
              home = {
                username = user;
                homeDirectory = "/Users/${user}";
              };
            }
          ];
        };

        # Linux Desktop
        "${user}@linux-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            ./home-manager/platform/linux-base.nix
            ./home-manager/profiles/development.nix
            ./home-manager/profiles/desktop.nix
            ./home-manager/hosts/linux-desktop.nix
            {
              home = {
                username = user;
                homeDirectory = "/home/${user}";
              };
            }
          ];
        };

        # Linux Server (minimal)
        "${user}@linux-server" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            ./home-manager/platform/linux-base.nix
            ./home-manager/profiles/minimal.nix
            ./home-manager/hosts/linux-server.nix
            {
              home = {
                username = user;
                homeDirectory = "/home/${user}";
              };
            }
          ];
        };
      };

      # Darwin (macOS) system configurations
      darwinConfigurations = {
        "macbook-work" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/hosts/macbook-work.nix;
            }
          ];
        };
      };

      # Development shells for different languages/projects
      devShells = forAllSystems (system:
        let
          pkgs = (nixpkgsFor system).legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              neovim
              tmux
            ];
            shellHook = ''
              echo "Welcome to the dotfiles development environment!"
            '';
          };

          ruby = pkgs.mkShell {
            buildInputs = with pkgs; [
              ruby_3_2
              bundler
              rubyPackages.solargraph
            ];
          };

          python = pkgs.mkShell {
            buildInputs = with pkgs; [
              python311
              python311Packages.pip
              python311Packages.virtualenv
              poetry
            ];
          };

          node = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_20
              nodePackages.pnpm
              nodePackages.yarn
            ];
          };

          go = pkgs.mkShell {
            buildInputs = with pkgs; [
              go_1_21
              gopls
              gotools
            ];
          };
        });

      # Helpful apps/scripts
      apps = forAllSystems (system: {
        # Quick switch command
        switch = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
            #!/usr/bin/env bash
            set -e
            echo "🔄 Switching Home Manager configuration..."

            # Detect hostname
            HOST=$(hostname -s)
            CONFIG="${user}@$HOST"

            # Check if specific config exists, otherwise use default
            if home-manager build --flake .#"$CONFIG" 2>/dev/null; then
              echo "✅ Using configuration: $CONFIG"
              home-manager switch --flake .#"$CONFIG"
            else
              echo "ℹ️  No specific config for $HOST, using default"
              home-manager switch --flake .#"${user}"
            fi
          '');
        };

        # Bootstrap installer
        bootstrap = {
          type = "app";
          program = ./scripts/bootstrap.sh;
        };
      });
    };
}