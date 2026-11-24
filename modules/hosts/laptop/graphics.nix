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
          enable = true;
          enable32Bit = true;
          package = hyprland-pkgs-unstable.mesa;
          package32 = hyprland-pkgs-unstable.pkgsi686Linux.mesa;
        };
      };
  };
}
