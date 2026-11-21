{
  den,
  inputs,
  lib,
  ...
}:
{
  den.reservedKeys = [ "settings" ];

  den.schema.host.includes = [
    den.batteries.mutual-provider
    den.aspects.home-manager
  ];
  den.schema.host.imports = [
    {
      options.settings = lib.mkOption {
        type = import ./_settings-type.nix { inherit den lib; };
        default = { };
        description = "Per-aspect typed settings for this host.";
      };
    }
  ];
  den.schema.host.home-manager.module = inputs.home-manager.nixosModules.home-manager;
}
