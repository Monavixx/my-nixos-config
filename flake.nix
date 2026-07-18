{
  description = "monavixx's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs, home-manager, nix-jetbrains-plugins, vicinae, catppuccin, ... }@inps: 
    let 
	    system = "x86_64-linux";
    in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit self; inputs = inps; };

      modules = [
        catppuccin.nixosModules.catppuccin
        ./hosts/nixos/configuration.nix
	      vicinae.nixosModules.default
        home-manager.nixosModules.home-manager
        {
	        home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inputs = inps; };
          home-manager.users.monavixx = import ./home/home.nix;
        }
      ];
    };
    homeConfigurations.monavixx = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."${system}";
      modules = [vicinae.homeManagerModules.default];
    };
  };
}
