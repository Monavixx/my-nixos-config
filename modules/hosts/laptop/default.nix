{ den, ... }: {
  den.hosts.x86_64-linux.laptop.users.monavixx = {
    email = "dperelygin0@gmail.com";
    fullName = "Monavixx";
    emailPasswordSecret = "dp0-gmail-app-password";
    groqApiKeySecret = "groq";
    flakeRoot = "/home/monavixx/nixos";
    rqbit = {
      httpPort = 3030;
      listenPort = 4240;
      downloadDir = "downloads";
    };
  };

  den.aspects.laptop = {
    includes = with den.aspects; [
      workstation
      bluetooth
      battery
      brightness
      poweralertd
    ];
    nixos = {
      imports = [ ./_hardware-configuration.nix ];

      fileSystems."/".options = [ "noatime" ];

      boot.initrd.luks.devices."luks-3815679e-a773-4c82-be2c-ca08327105af".device =
        "/dev/disk/by-uuid/3815679e-a773-4c82-be2c-ca08327105af";

    };
  };
}
