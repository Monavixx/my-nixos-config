{ inputs, ... }:
{
  den.aspects.awww.homeManager =
    { lib, pkgs, ... }:
    let
      awww = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
    in
    {
      home.packages = [ awww ];

      systemd.user.services.awww-daemon = {
        Unit = {
          Description = "awww wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = lib.getExe' awww "awww-daemon";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
