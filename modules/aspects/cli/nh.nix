{
  den.aspects.nh.homeManager = { user, ... }: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = user.flakeRoot; # sets NH_OS_FLAKE variable for you
    };
  };
}
