{ den, ... }:
{

  den.aspects.wallpapers = {
    includes = with den.aspects; [
      awww
      awww-random
    ];
    homeManager =
      { config, pkgs, ... }:
      {
        home.file."${config.xdg.userDirs.pictures}/wallpapers".source = pkgs.fetchFromGitHub {
          owner = "monavixx";
          repo = "walls-catppuccin-mocha";
          rev = "7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
          sha256 = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
        };
      };
  };
}
