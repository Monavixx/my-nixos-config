{
  den.aspects.home-manager = {
    homeManager = {

    };
    provides.to-hosts.nixos = { user }: {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };

    };
  };
}
