{
  den.aspects.kdeconnect = {
    nixos = {
      programs.kdeconnect.enable = true; # also opens the firewall ports it needs
    };
  };
}
