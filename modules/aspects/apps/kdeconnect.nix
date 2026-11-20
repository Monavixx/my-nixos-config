{
  den.aspects.kdeconnect.nixos = { pkgs, ... }: {
    programs.kdeconnect.enable = true; # also opens the firewall ports it needs
    environment.systemPackages = with pkgs; [
      kdePackages.krdp
      kdePackages.krdc
    ];
  };
}
