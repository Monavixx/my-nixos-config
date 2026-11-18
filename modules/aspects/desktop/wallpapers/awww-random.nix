{
  den.aspects.awww-random.homeManager =
    { lib, pkgs, ... }:
    let
      awwwRandom = pkgs.writeShellScriptBin "awww-random" (builtins.readFile ./awww-random.sh);
    in
    {
      home.packages = [ awwwRandom ];

      systemd.user.services.awww-random = {
        Unit = {
          Description = "Set a random wallpaper via awww";
          Wants = [ "awww-daemon.service" ];
          After = [ "awww-daemon.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe awwwRandom;
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };

      systemd.user.timers.awww-random = {
        Unit.Description = "Run awww-random every 30 minutes";
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "30min";
          Unit = "awww-random.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
