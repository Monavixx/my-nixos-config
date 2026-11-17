{
  flake.modules.nixos.desktop-session = { pkgs, ... }: {
    security.polkit.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
