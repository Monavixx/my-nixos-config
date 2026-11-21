{ inputs, ... }:
{
  den.aspects.laptop = {
    nixos =
      { pkgs, ... }:
      let
        hyprland-pkgs-unstable =
          inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        hardware.amdgpu.initrd.enable = true;
        hardware.graphics = {
          package = hyprland-pkgs-unstable.mesa;
        };
      };
  };
}
