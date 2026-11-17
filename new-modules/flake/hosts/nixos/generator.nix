{
  config,
  lib,
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos = lib.mapAttrs' (
    name: host:
    lib.nameValuePair "host-${name}" {
      imports = (map (user: self.modules.nixos."user-${user}") host.users) ++ [ self.modules.nixos.base ];
      home-manager.users = lib.genAttrs host.users (_: {
        my.hostname = name;
      });
      networking.hostName = lib.mkDefault name;
      system.stateVersion = host.stateVersion;
    }
  ) config.hosts;

  flake.nixosConfigurations = lib.mapAttrs (
    name: _host:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [ self.modules.nixos."host-${name}" ];
    }
  ) config.hosts;
}
