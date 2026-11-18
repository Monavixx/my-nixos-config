{
  den.aspects.fprintd.nixos = {
    services.fprintd = {
      enable = true;
      enablePam = false;
    };
    security.pam.services.sudo.fprintAuth = true;
    security.pam.services.polkit-1.fprintAuth = true;
  };
}
