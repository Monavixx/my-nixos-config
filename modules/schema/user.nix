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
        rqbit.instances = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                httpPort = lib.mkOption { type = lib.types.port; };
                listenPort = lib.mkOption { type = lib.types.port; };
                downloadDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                stateDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
            }
          );
        };
      };
    }
  ];
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
