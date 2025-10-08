{
  description = "Levi's Nix + Home Manager Configuration";

  # Binary cache configuration
  nixConfig = {
    # Uncomment to enable nix-community cache for faster builds
    # extra-substituters = [
    #   "https://nix-community.cachix.org"
    # ];
    # extra-trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
  };

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

    # nix-homebrew for declarative Homebrew management
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    # Homebrew tap inputs
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin, flake-utils, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, ... }@inputs:
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

        # LFX001 - Primary macOS machine (Workstation)
        "${user}@LFX001" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-darwin.legacyPackages.aarch64-darwin;
          modules = [
            ./home-manager/home.nix
            ./home-manager/platform/darwin-base.nix
            ./home-manager/profiles/workstation.nix  # Full workstation with GUI
            ./home-manager/profiles/platform.nix      # Platform engineering tools
            ./home-manager/hosts/LFX001.nix
            {
              home = {
                username = user;
                homeDirectory = "/Users/${user}";
              };
            }
          ];
        };

        # LFX004 - Linux laptop (NixOS ready)
        "${user}@LFX004" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            ./home-manager/hosts/LFX004.nix
            {
              home = {
                username = user;
                homeDirectory = "/home/${user}";
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
            ./home-manager/profiles/server.nix  # Minimal server profile
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
        "LFX001" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;  # Enable for Apple Silicon Macs
                user = user;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/hosts/LFX001.nix;
            }
          ];
        };

        "macbook-work" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;  # Enable for Apple Silicon Macs
                user = user;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/hosts/macbook-work.nix;
            }
          ];
        };
      };

      # NixOS system configurations
      nixosConfigurations = {
        LFX004 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/hosts/LFX004/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/hosts/LFX004.nix;
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
              ruby_3_4
              bundler
              rubyPackages_3_4.solargraph
            ];
          };

          python = pkgs.mkShell {
            buildInputs = with pkgs; [
              python313
              python313Packages.pip
              python313Packages.virtualenv
              poetry
            ];
          };

          node = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_24
              nodePackages.pnpm
              nodePackages.yarn
            ];
          };

          go = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              gotools
            ];
          };
        });

      # Helpful apps/scripts
      apps = forAllSystems (system: {
        # Build configuration without switching
        build = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "build" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/build.sh}
          '');
          meta = {
            description = "Build Nix configuration without switching";
            platforms = [ system ];
          };
        };

        # Build and switch configuration
        switch = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/switch.sh}
          '');
          meta = {
            description = "Build and switch to new Nix configuration";
            platforms = [ system ];
          };
        };

        # Rollback to previous generation
        rollback = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "rollback" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/rollback.sh}
          '');
          meta = {
            description = "Rollback to previous Nix generation";
            platforms = [ system ];
          };
        };

        # Update flake inputs
        update = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "update" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/update.sh}
          '');
          meta = {
            description = "Update all flake inputs to latest versions";
            platforms = [ system ];
          };
        };

        # Garbage collect old generations
        clean = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "clean" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/clean.sh} "$@"
          '');
          meta = {
            description = "Garbage collect old Nix generations";
            platforms = [ system ];
          };
        };

        # Bootstrap installer for new machines
        bootstrap = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "bootstrap" ''
            #!/usr/bin/env bash
            cd ${./.}
            exec ${./apps/bootstrap.sh} "$@"
          '');
          meta = {
            description = "Bootstrap dotfiles on a new machine";
            platforms = [ system ];
          };
        };
      });
    };
}