{
  den.aspects.kdeconnect = {
    nixos = {
      programs.kdeconnect = {
        enable = true; # also opens the firewall ports it needs
      };
    };
    provides.to-users.homeManager = {
      xdg.configFile."autostart/org.kde.kdeconnect.daemon.desktop".text = ''
        [Desktop Entry]
        Hidden=true
      '';
    };
  };
}
