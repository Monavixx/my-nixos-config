{
  flake.modules.nixos.dns-quad9 = {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
        ];
        DNSOverTLS = "true";
        Domains = [ "~." ];
        FallbackDNS = [ ];
      };
    };
  };
}
