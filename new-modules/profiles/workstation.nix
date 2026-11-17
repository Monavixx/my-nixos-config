{ self, ... }:
{
  flake.modules.nixos.workstation = {
    imports = with self.modules.nixos; [
      audio
      locale
      fonts
      hyprland
      thunar
      kdeconnect
      amnezia-vpn
      zsh
      networking
      boot-systemd
    ];
  };
}
