{ den, ... }:
{
  den.aspects.workstation.includes = with den.aspects; [
    audio
    audio-realtime
    agenix
    ignore-power-key
    nix
    nixpkgs
    boot-systemd
    kernel
    locale
    dns-quad9
    fonts
    networking
    kdeconnect
    amnezia-vpn
    thunar
  ];
}
