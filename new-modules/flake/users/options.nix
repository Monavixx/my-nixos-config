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
          flakeRoot = lib.mkOption {
            type = lib.types.str;
            description = "Absolute path of this user's live checkout of the flake.";
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
