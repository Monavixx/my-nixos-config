{
  den.aspects.boot-systemd = {
    nixos = {
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
      };
    };
  };
}
