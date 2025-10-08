{ config, pkgs, lib, ... }:

{
  # Global ESLint configuration
  # Note: Modern projects should use project-specific configs instead
  # This is provided for backward compatibility only

  home.file.".eslintrc.json".text = builtins.toJSON {
    extends = "airbnb";
    parser = "babel-eslint";
    plugins = [ "react" ];
  };
}
