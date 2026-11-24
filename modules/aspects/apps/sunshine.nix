{
  den.aspects.sunshine = {
    nixos = {
      # start the service manually before going to
      # https://localhost:47990
      services.sunshine = {
        enable = true;
        openFirewall = true;

        settings = {
          capture = "wlr";
          tray = "never";
        };
      };
    };
    user.extraGroups = [ "uinput" ];
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.moonlight-qt ];
    };
  };
}
