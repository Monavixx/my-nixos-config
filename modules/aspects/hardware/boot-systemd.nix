{
  den.aspects.boot-systemd = {
    nixos = { pkgs, lib, ... }: {
      boot = {
        loader.systemd-boot = {
          enable = true;
        };
        loader.efi.canTouchEfiVariables = true;
        plymouth = {
          enable = true;
        };
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "splash"
        ];
      };
    };
  };
}
