{ self, ... }:
{
  flake.modules.homeManager.wallpapers =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      awww-random = pkgs.writeShellScriptBin "awww-random" (builtins.readFile ./awww-random.sh);
    in
    {
      imports = [ self.modules.homeManager.awww ];

      home.packages = [ awww-random ];

      systemd.user.services.awww-random = {
        Unit = {
          Description = "Set a random wallpaper via awww";
          Wants = [ "awww-daemon.service" ];
          After = [ "awww-daemon.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe awww-random;
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

      home.file."${config.xdg.userDirs.pictures}/wallpapers".source = pkgs.fetchFromGitHub {
        owner = "monavixx";
        repo = "walls-catppuccin-mocha";
        rev = "7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
        sha256 = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
      };
    };
}
