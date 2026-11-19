{ den, inputs, ... }:
{
  den.schema.host.includes = [
    den.batteries.mutual-provider
    den.aspects.home-manager
  ];
  den.schema.host.home-manager.module = inputs.home-manager.nixosModules.home-manager;
}
