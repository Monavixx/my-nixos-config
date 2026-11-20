{
  den.aspects.taskwarrior.homeManager =
    { pkgs, ... }:
    {
      programs.taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;
      };
    };
}
