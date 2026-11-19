{
  den.aspects.home-manager = {
    nixos = {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
