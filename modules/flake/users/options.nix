{ lib, ... }:
{
  options.users = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          fullName = lib.mkOption { type = lib.types.str; };
          email = lib.mkOption {
            type = lib.types.str;
          };
          extraGroups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
          locale = lib.mkOption {
            type = lib.types.str;
            default = "en_US.UTF-8";
          };
        };
      }
    );
  };
}
