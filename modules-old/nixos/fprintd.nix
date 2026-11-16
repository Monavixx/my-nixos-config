{ pkgs, ... }:
{
  # fprintd-enroll to register a new fingerprint.
  services.fprintd = {
    enable = true;
    enablePam = false;
    package = pkgs.fprintd-ft9362;
  };
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.polkit-1.fprintAuth = true;
}
