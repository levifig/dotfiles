{ lib, ... }:

{
  # Centralized user information
  # Override these in host-specific configs as needed

  options = {
    userInfo = {
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Levi Figueira";
        description = "Full name for git commits, etc.";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "me@levifig.com";
        description = "Primary email address";
      };

      githubUser = lib.mkOption {
        type = lib.types.str;
        default = "levifig";
        description = "GitHub username";
      };

      gitSigningKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT8O1BCE6d5mjzD+k4VLeCyM5hjZ2kWnAr+p7XlMsmy";
        description = "SSH signing key for git commits";
      };
    };
  };
}
