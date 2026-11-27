{
  den.aspects.home-manager = {
    nixos = { pkgs, ... }: {
      home-manager = {
        backupCommand = "${pkgs.trashy}/bin/trashy put";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
