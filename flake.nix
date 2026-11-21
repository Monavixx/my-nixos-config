{
  description = "monavixx's NixOS config";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    den.url = "github:denful/den";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    libfprint-ft9362-src = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = "libfprint";
      rev = "19375e57cbb95839330505f465e3428c7120f0e5";
      flake = false;
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trashy = {
      url = "github:oberblastmeister/trashy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant.url = "github:abenz1267/elephant";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    walker-catppuccin = {
      url = "github:krymancer/walker";
      flake = false;
    };
    reaper-flake.url = "github:9Prestidigitator/reaper-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
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
}
