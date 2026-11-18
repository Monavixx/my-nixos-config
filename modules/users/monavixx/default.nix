{ den, ... }:
{
  den.aspects.alice = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
