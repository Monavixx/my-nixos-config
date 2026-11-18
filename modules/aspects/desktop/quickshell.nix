{ den, inputs, ... }:
{
  den.aspects.quickshell = {
    nixos = { lib, config, ... }: {
      security.pam.services.quickshell-fprint = lib.mkIf config.services.fprintd.enable {
        fprintAuth = true;
        unixAuth = false; # fingerprint only; the password has its own service
      };
    };
  };
}
