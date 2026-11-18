{
  den.aspects.desktop-session = {
    nixos = { pkgs, ... }: {
      security.polkit.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
  };
}
