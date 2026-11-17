{ self, inputs, ... }:
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      hyprland = inputs.hyprland.packages.${system};
    in
    {
      imports = [ self.modules.nixos.desktop-session ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
        package = hyprland.hyprland;
        portalPackage = hyprland.xdg-desktop-portal-hyprland;
      };

      # the compositor handles the power key, not logind
      services.logind.settings.Login.HandlePowerKey = "ignore";
    };
}
