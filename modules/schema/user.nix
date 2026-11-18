{ lib, ... }:
{
  den.schema.user.imports = [
    {
      options = {
        email = lib.mkOption {
          type = lib.types.str;
          description = "Primary email address for this user.";
        };
        fullName = lib.mkOption {
          type = lib.types.str;
          description = "User's display name for email.";
        };
        emailPasswordSecret = lib.mkOption {
          type = lib.types.str;
          description = "Name of the agenix secret containing this user's email app password.";
        };
      };
    }
  ];
}
