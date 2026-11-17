{
  lib,
  config,
  self,
  ...
}:
{
  flake.modules.nixos = lib.mapAttrs' (
    name: user:
    lib.nameValuePair "user-${name}" {

      imports = [ self.modules.nixos.home-manager ];
      users.users.${name} = {
        isNormalUser = true;
        description = user.fullName;
        extraGroups = user.extraGroups;
      };

      home-manager.users.${name} = {
        imports = [ self.modules.homeManager."user-${name}" ];
      };
    }
  ) config.users;

  flake.modules.homeManager = lib.mapAttrs' (
    name: user:
    lib.nameValuePair "user-${name}" {

      imports = [
        self.modules.homeManager.base
      ];
      home.language.base = user.locale;
      my.flakeRoot = lib.mkDefault user.flakeRoot;
    }
  ) config.users;
}
