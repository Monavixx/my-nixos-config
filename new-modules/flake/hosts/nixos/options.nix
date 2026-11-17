{ lib, ... }:
{
  options.hosts = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };
          stateVersion = lib.mkOption { type = lib.types.str; };
          users = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Names from `users` that get an account on this host.";
          };
        };
      }
    );
  };
}
