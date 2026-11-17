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
      home = {
        username = name;
        homeDirectory = "/home/${name}";
        language.base = user.locale;
        sessionVariables = {
          SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
          GDK_BACKEND = "wayland";
          NIXOS_OZONE_WL = "1";
          # TODO: replace this mechanic
          # QS_HOST_TYPE = hostname;
        };
      };
      my.flakeRoot = lib.mkDefault user.flakeRoot;
    }
  ) config.users;
}
