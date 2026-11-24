{
  den.aspects.sunshine = {
    nixos = {
      #https://localhost:47990
      services.sunshine = {
        enable = true;
        autoStart = true;
        openFirewall = true;

        settings = {
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
