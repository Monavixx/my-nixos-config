{ ... }:
{
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        # kdeconnect
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        # kdeconnect
        from = 1714;
        to = 1764;
      }
    ];
  };
}
