{ den, lib, ... }:
{
  den.default.includes = [
    den.batteries.hostname
    den.batteries.define-user
  ];
  den.default.homeManager.home.stateVersion = lib.mkDefault "26.05";
  den.default.nixos.system.stateVersion = lib.mkDefault "26.05";
}
