{ config, pkgs, lib, ... }:

# Declarative Dock Management
# Based on: https://github.com/dustinlyons/nixos-config/blob/main/modules/darwin/dock/default.nix
#
# This module allows you to declaratively manage your macOS Dock
# Set enable = true to activate

with lib;
let
  cfg = config.darwin.dock;
  inherit (pkgs) stdenv dockutil;
in
{
  options = {
    darwin.dock = {
      enable = mkOption {
        description = "Enable declarative dock management";
        default = false;  # Disabled by default
        type = types.bool;
      };

      entries = mkOption {
        description = "Entries on the Dock";
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption {
              type = str;
              description = "Path to the application or folder";
            };
            section = lib.mkOption {
              type = str;
              default = "apps";
              description = "Dock section: apps, others, or all";
            };
            options = lib.mkOption {
              type = str;
              default = "";
              description = "Additional dockutil options";
            };
          };
        });
        default = [];
      };

      username = mkOption {
        description = "Username to apply the dock settings to";
        type = types.str;
        default = "levifig";
      };
    };
  };

  config = mkIf cfg.enable (
    let
      normalize = path: if hasSuffix ".app" path then path + "/" else path;
      entryURI = path:
        "file://"
        + (builtins.replaceStrings
          [ " " "!" "\"" "#" "$" "%" "&" "'" "(" ")" ]
          [ "%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29" ]
          (normalize path)
        );
      wantURIs = concatMapStrings (entry: "${entryURI entry.path}\n") cfg.entries;
      createEntries = concatMapStrings
        (entry:
          "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n"
        )
        cfg.entries;
    in
    {
      system.activationScripts.postActivation.text = ''
        echo >&2 "Setting up the Dock for ${cfg.username}..."
        su ${cfg.username} -s /bin/sh <<'USERBLOCK'
        haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
        if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
          echo >&2 "Resetting Dock."
          ${dockutil}/bin/dockutil --no-restart --remove all
          ${createEntries}
          killall Dock
        else
          echo >&2 "Dock setup complete."
        fi
        USERBLOCK
      '';
    }
  );
}

# Example configuration (uncomment and modify to use):
# {
#   darwin.dock = {
#     enable = true;
#     username = "levifig";
#     entries = [
#       # Applications
#       { path = "/Applications/1Password.app/"; }
#       { path = "/Applications/Arc.app/"; }
#       { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }  # Nix-installed app
#       { path = "/Applications/Slack.app/"; }
#       { path = "/Applications/Discord.app/"; }
#       { path = "/Applications/Spotify.app/"; }
#       { path = "/Applications/Visual Studio Code.app/"; }
#       { path = "/Applications/Zed.app/"; }
#
#       # System apps
#       { path = "/System/Applications/Messages.app/"; }
#       { path = "/System/Applications/Calendar.app/"; }
#       { path = "/System/Applications/Music.app/"; }
#       { path = "/System/Applications/Photos.app/"; }
#
#       # Folders (must be in "others" section)
#       {
#         path = "${config.users.users.levifig.home}/Downloads";
#         section = "others";
#         options = "--sort name --view grid --display stack";
#       }
#       {
#         path = "${config.users.users.levifig.home}/Documents";
#         section = "others";
#         options = "--sort name --view grid --display folder";
#       }
#     ];
#   };
# }
