{
  flake.modules.nixos.kdeconnect = {
    programs.kdeconnect.enable = true; # also opens the firewall ports it needs
  };
}
