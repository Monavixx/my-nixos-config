{ config, lib, ... }:
{
  options.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }: {
          options = {
            home = lib.mkOption {
              type = lib.types.str;
              default = "/home/${name}";
            };
            xdg = lib.genAttrs [ "desktop" "documents" "download" "music" "pictures" "videos" ] (
              dir:
              lib.mkOption {
                type = lib.types.str;
                default = "${config.home}/${lib.toUpper (lib.substring 0 1 dir)}${lib.substring 1 (-1) dir}";
              }
            );
          };
        }
      )
    );
  };

  config.flake.modules.homeManager = lib.mapAttrs' (
    name: user:
    lib.nameValuePair "user-${name}" {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      }
      // user.xdg;
    }
  ) config.users;
}
