{ den, ... }:
{
  den.aspects.monavixx = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ]
    ++ (with den.aspects; [
      agenix
      hyprland
      nix-index
      kitty
    ]);
  };
}
