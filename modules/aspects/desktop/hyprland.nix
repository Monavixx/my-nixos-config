{ inputs, den, ... }:
{
  den.aspects.hyprland = {
    includes = with den.aspects; [ desktop-session ];
    nixos =
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        hyprland = inputs.hyprland.packages.${system};
      in
      {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
          xwayland.enable = true;
          package = hyprland.hyprland;
          portalPackage = hyprland.xdg-desktop-portal-hyprland;
        };
      };
  };
}
