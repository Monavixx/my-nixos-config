{ den, ... }:
{
  den.aspects.workstation.includes = with den.aspects; [
    ignore-power-key
    nix
    nixpkgs
    boot-systemd
  ];
}
