{ inputs, ... }:
{
  den.aspects.nixpkgs.nixos.nixpkgs.config.allowUnfree = true;
  den.aspects.nur.provides.to-hosts.nixos = {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
  };
}
