{
  description = "monavixx's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # roslynUpdatePatch = {
    #   url = "https://github.com/NixOS/nixpkgs/pull/572156.patch";
    #   flake = false;
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-jetbrains-plugins = {
    #   url = "github:nix-community/nix-jetbrains-plugins";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    boilersharp = {
      url = "github:angeljreyes/boilersharp.nvim";
      flake = false;
    };
    telescope-luasnip = {
	url = "github:benfowler/telescope-luasnip.nvim";
	flake = false;
    };
    melodec = {
      url = "github:Monavixx/Melodec";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
        }:
        let
          # patchedNixpkgs = nixpkgs.legacyPackages.${system}.applyPatches {
          #   name = "nixpkgs-roslyn-ls-update";
          #   src = nixpkgs;
          #   patches = [ inputs.roslynUpdatePatch ];
          # };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname self; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs hostname self; };
              home-manager.users.monavixx = import ./hosts/${hostname}/home.nix;
            }
            # {
            #   nixpkgs.overlays = [
            #     (final: prev: {
            #       roslyn-ls = final.callPackage (patchedNixpkgs + "/pkgs/by-name/ro/roslyn-ls/package.nix") { };
            #     })
            #   ];
            # }
          ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkHost { hostname = "laptop"; };
        desktop = mkHost { hostname = "desktop"; };
      };
    };
}
