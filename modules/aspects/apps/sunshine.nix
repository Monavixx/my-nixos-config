{
  den.aspects.sunshine = {
    nixos = {
      # start the service manually before going to
      # https://localhost:47990
      services.sunshine = {
        enable = true;
        autoStart = false; # Prevents the systemd user service from starting on login
        capSysAdmin = true; # Keep if using Wayland
        openFirewall = true;

        settings = {
          system_tray = "disabled"; # Disables the tray icon and desktop notifications
          capture = "wlr";
        };
      };
    };
    user.extraGroups = [ "uinput" ];
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.moonlight-qt ];
    };
  };
}
