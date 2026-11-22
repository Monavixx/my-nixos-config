{
  den.aspects.syncthing = {
    homeManager = {
      services.syncthing = {
        enable = true;
        guiAddress = "127.0.0.1:8384";
      };
    };

    nixos.networking.firewall = {
      allowedTCPPorts = [
        22000
      ];

      allowedUDPPorts = [
        22000
        21027
      ];
    };
  };
}
