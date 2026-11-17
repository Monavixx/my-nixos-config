{ ... }:
{
  flake.modules.nixos.fprintd =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.my.fprintd.libfprint.package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.libfprint;
        description = "libfprint build with the driver for this machine's reader.";
      };
      config = {
        # fprintd-enroll to register a new fingerprint.
        services.fprintd = {
          enable = true;
          enablePam = false;
          package = config.my.fprintd.libfprint.package;
        };
        security.pam.services.sudo.fprintAuth = true;
        security.pam.services.polkit-1.fprintAuth = true;
      };
    };
}
