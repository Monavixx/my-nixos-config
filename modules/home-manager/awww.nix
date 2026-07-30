{ config, pkgs, ... }:
let
  awww-random = ( import ./awww-random.nix { inherit pkgs; } );
in {
  systemd.user.services.awww-random = {
    Unit.Description = "Set a random wallpaper via awww";
    Service = {
      Type = "oneshot";
      ExecStart = "${awww-random}/bin/awww-random";
    };
  };

  systemd.user.timers.awww-random = {
    Unit.PartOf = [ "awww-random.service" ];
    Unit.Description = "Run awww-random every 30 minutes";
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "30min";
      Unit = "awww-random.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  home.file."${config.xdg.userDirs.pictures}/wallpapers" = {
    source = pkgs.fetchFromGitHub {
      owner = "monavixx";
      repo = "walls-catppuccin-mocha";
      rev = "7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
      sha256 = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
    };
  };
}
