{ den, ... }: {
  den.hosts.x86_64-linux.laptop = {
    users.monavixx = import ../../users/monavixx/_user.nix;
    settings.quickshell.fingerprint = true;
  };

  den.aspects.laptop = {
    includes = with den.aspects; [
      workstation
      lanzaboote
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

    provides.to-users.homeManager = {
      xdg.configFile."hypr/host.lua".source = ./hyprland.lua;
    };
  };
}
