{ config, pkgs, lib, ... }:

let
  # Use absolute path to fonts submodule (outside flake's git tree)
  fontsPath = "${config.home.homeDirectory}/.dotfiles/.fonts/private";
  fontsExist = builtins.pathExists fontsPath;
in
{
  # Install private fonts from submodule (only if initialized)
  home.packages = lib.optionals fontsExist [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "private-fonts";
      src = builtins.path {
        path = fontsPath;
        name = "private-fonts-source";
      };

      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/fonts/truetype
        mkdir -p $out/share/fonts/opentype

        # Find and install all font files
        find $src -type f -name "*.ttf" -exec install -Dm644 {} $out/share/fonts/truetype/{} \;
        find $src -type f -name "*.otf" -exec install -Dm644 {} $out/share/fonts/opentype/{} \;

        runHook postInstall
      '';

      meta = with lib; {
        description = "Private licensed fonts";
        platforms = platforms.all;
      };
    })
  ];

  # Enable fontconfig on Linux
  fonts.fontconfig.enable = lib.mkDefault true;
}
