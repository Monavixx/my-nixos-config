{ den, inputs, ... }:
{
  den.aspects.quickshell = {
    includes = with den.aspects; [
      awww
      awww-random
      wallpapers
    ];
    nixos = { lib, config, ... }: {
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
  };
}
