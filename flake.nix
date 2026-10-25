{
  description = "monavixx's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker-catppuccin = {
      url = "github:krymancer/walker";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vicinae = {
    #   url = "github:vicinaehq/vicinae";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # vicinae-extensions = {
    #   url = "github:vicinaehq/extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      defaults = rec {
        username = "monavixx";
        flakeRoot = "/home/${username}/nixos";
        system = "x86_64-linux";
        theme = rec {
          flavor = "mocha";
          accent = "flamingo";
          name = "catppuccin-${flavor}-${accent}-standard";
        };
      };
      mkHost =
        {
          ...
        }@args:
        let
          host = defaults // args;
        in
        nixpkgs.lib.nixosSystem {
          inherit (host) system;
          specialArgs = {
            inherit inputs host;
            inherit (host) hostname username flakeRoot;
          };
          modules = [
            ./hosts/${host.hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs host;
                inherit (host) hostname username flakeRoot;
              };
              home-manager.users.${host.username} = import ./hosts/${host.hostname}/home.nix;
            }
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
