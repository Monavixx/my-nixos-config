{ inputs, ... }:
{
  flake.modules.nixos.home-manager = { lib, config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        {
          home.stateVersion = lib.mkDefault config.system.stateVersion;
        }
      ];
    };
  };
}
