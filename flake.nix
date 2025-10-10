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

    # Disko - Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Custom taps
    tap-dagger = {
      url = "github:dagger/homebrew-tap";
      flake = false;
    };
    tap-felixkratz = {
      url = "github:felixkratz/homebrew-formulae";
      flake = false;
    };
    tap-jackielii = {
      url = "github:jackielii/homebrew-tap";
      flake = false;
    };
    tap-koekeishiya = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };
    tap-nikitabobko = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-darwin,
      home-manager,
      darwin,
      disko,
      flake-utils,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      ...
    }@inputs:
    let
      # System types
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate system-specific outputs
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # User configuration
      user = "levifig";

      # Helper to determine if system is Darwin
      isDarwin =
        system:
        builtins.elem system [
          "x86_64-darwin"
          "aarch64-darwin"
        ];

      # Get appropriate nixpkgs for system
      nixpkgsFor = system: if isDarwin system then nixpkgs-darwin else nixpkgs;
    in
    {
      # Home Manager Configurations
      homeConfigurations =
        let
          # Package overrides for all configurations
          packageOverrides = final: prev: {
            # Override python3 to include dulwich without tests
            python3 = prev.python3.override {
              packageOverrides = pyfinal: pyprev: {
                dulwich = pyprev.dulwich.overridePythonAttrs (old: {
                  doCheck = false; # Skip tests due to GPG signing failures in sandbox
                });
              };
            };

            # Also update python3Packages to use the overridden python3
            python3Packages = final.python3.pkgs;

            # Override awscli2 to skip flaky tests
            awscli2 = prev.awscli2.overridePythonAttrs (old: {
              doCheck = false; # Skip flaky wizard tests
            });
          };
        in
        {
          # Default configuration (auto-detected)
          "${user}" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = builtins.currentSystem;
              config.allowUnfree = true;
              overlays = [ packageOverrides ];
            };
            modules = [
              ./home-manager/home.nix
              {
                home = {
                  username = user;
                  homeDirectory = if isDarwin builtins.currentSystem then "/Users/${user}" else "/home/${user}";
                };

                # Disable manual generation to avoid builtins.toFile warnings
                manual = {
                  html.enable = false;
                  json.enable = false;
                  manpages.enable = false;
                };
              }
            ];
          };

          # LFX001 - Primary macOS machine (Workstation)
          "${user}@LFX001" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs-darwin {
              system = "aarch64-darwin";
              config.allowUnfree = true;
              overlays = [ packageOverrides ];
            };
            modules = [
              ./home-manager/home.nix
              ./home-manager/platform/darwin-base.nix
              ./home-manager/profiles/workstation.nix # Full workstation with GUI (includes development.nix)
              ./home-manager/profiles/cli-tools.nix # Language package manager tools
              ./home-manager/hosts/LFX001.nix
              {
                home = {
                  username = user;
                  homeDirectory = "/Users/${user}";
                };

                # Disable manual generation to avoid builtins.toFile warnings
                manual = {
                  html.enable = false;
                  json.enable = false;
                  manpages.enable = false;
                };
              }
            ];
          };

          # LFX004 - Linux laptop (NixOS ready)
          "${user}@LFX004" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              config.allowUnfree = true;
              overlays = [ packageOverrides ];
            };
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
        };

      # Darwin (macOS) system configurations
      darwinConfigurations = {
        "LFX001" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            # Pass nixpkgs with overlays to the darwin system
            pkgs = import nixpkgs-darwin {
              system = "aarch64-darwin";
              config.allowUnfree = true;
              overlays = [
                # Package overrides
                (final: prev: {
                  # Override awscli2 to skip flaky tests
                  awscli2 = prev.awscli2.overridePythonAttrs (old: {
                    doCheck = false;
                  });

                  # Override python3 to include dulwich without tests
                  python3 = prev.python3.override {
                    packageOverrides = pyfinal: pyprev: {
                      dulwich = pyprev.dulwich.overridePythonAttrs (old: {
                        doCheck = false;
                      });
                    };
                  };
                })
              ];
            };
          };
          modules = [
            ./darwin/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true; # Enable for Apple Silicon Macs
                user = user;
                taps = {
                  # Official Homebrew taps
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;

                  # Custom taps
                  "dagger/homebrew-tap" = inputs.tap-dagger;
                  "felixkratz/homebrew-formulae" = inputs.tap-felixkratz;
                  "jackielii/homebrew-tap" = inputs.tap-jackielii;
                  "koekeishiya/homebrew-formulae" = inputs.tap-koekeishiya;
                  "nikitabobko/homebrew-tap" = inputs.tap-nikitabobko;
                };
                mutableTaps = false; # Fully declarative - all taps managed by Nix
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = {
                imports = [
                  ./home-manager/home.nix
                  ./home-manager/platform/darwin-base.nix
                  ./home-manager/profiles/workstation.nix
                  ./home-manager/profiles/cli-tools.nix
                  ./home-manager/hosts/LFX001.nix
                ];

                # Disable manual generation to avoid builtins.toFile warnings
                manual = {
                  html.enable = false;
                  json.enable = false;
                  manpages.enable = false;
                };
              };
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
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = {
                imports = [ ./home-manager/hosts/LFX004.nix ];

                # Disable manual generation to avoid builtins.toFile warnings
                manual = {
                  html.enable = false;
                  json.enable = false;
                  manpages.enable = false;
                };
              };
            }
          ];
        };
      };

      # Development shells for different languages/projects
      devShells = forAllSystems (
        system:
        let
          pkgs = (nixpkgsFor system).legacyPackages.${system};
        in
        {
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
        }
      );

      # Helpful apps/scripts
      apps = forAllSystems (system: {
        # Build configuration without switching
        build = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "build" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/build.sh}
            ''
          );
          meta = {
            description = "Build Nix configuration without switching";
            platforms = [ system ];
          };
        };

        # Build and switch configuration
        switch = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/switch.sh}
            ''
          );
          meta = {
            description = "Build and switch to new Nix configuration";
            platforms = [ system ];
          };
        };

        # Rollback to previous generation
        rollback = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "rollback" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/rollback.sh}
            ''
          );
          meta = {
            description = "Rollback to previous Nix generation";
            platforms = [ system ];
          };
        };

        # Update flake inputs
        update = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "update" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/update.sh}
            ''
          );
          meta = {
            description = "Update all flake inputs to latest versions";
            platforms = [ system ];
          };
        };

        # Garbage collect old generations
        clean = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "clean" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/clean.sh} "$@"
            ''
          );
          meta = {
            description = "Garbage collect old Nix generations";
            platforms = [ system ];
          };
        };

        # Bootstrap installer for new machines
        bootstrap = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${system}.writeShellScript "bootstrap" ''
              #!/usr/bin/env bash
              cd ${./.}
              exec ${./apps/bootstrap.sh} "$@"
            ''
          );
          meta = {
            description = "Bootstrap dotfiles on a new machine";
            platforms = [ system ];
          };
        };
      });
    };
}
