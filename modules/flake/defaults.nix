{ den, lib, ... }:
{
  den.default.includes = [
    den.batteries.hostname
    den.batteries.define-user
    ({ user, ... }: { user.description = user.fullName; })
  ];
  den.default.homeManager.home.stateVersion = lib.mkDefault "26.05";
  den.default.nixos.system.stateVersion = lib.mkDefault "26.05";
}
