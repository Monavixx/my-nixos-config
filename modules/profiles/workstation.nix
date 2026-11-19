{ den, ... }:
{
  den.aspects.workstation.includes = with den.aspects; [
    ignore-power-key
    nix
    nixpkgs
    boot-systemd
    kernel
    locale
    dns-quad9
    fonts
    networking
    poweralertd
  ];
}
