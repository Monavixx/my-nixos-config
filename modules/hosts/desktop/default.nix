{ den, ... }:
{
  den.aspects.desktop = {
    includes = [ den.aspects.workstation ];
    nixos = {
      imports = [ ./_hardware-configuration.nix ];
    };
  };
}
