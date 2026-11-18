{ den, ... }:
{
  den.aspects.quickshell = {
    includes = with den.aspects; [ wallpapers ];
    provides.to-hosts.nixos = { lib, config, ... }: {
      security.pam.services = {
        quickshell-fprint = lib.mkIf config.services.fprintd.enable {
          fprintAuth = true;
          unixAuth = false; # fingerprint only; the password has its own service
        };
        quickshell-lock = {
          unixAuth = true;
          fprintAuth = false;
        };
      };
    };
    homeManager = {
      programs.quickshell = {
        enable = true;
        configs.main = ./config;
        activeConfig = "main";
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };
    };
  };
}
