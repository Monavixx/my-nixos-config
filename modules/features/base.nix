{ self, ... }:
{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
      nixpkgs
      nix
    ];
  };
}
