{ den, ... }:
{
  den.aspects.monavixx = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ]
    ++ (with den.aspects; [
      email
      hyprland
      nix-index
      kitty
      quickshell
      catppuccin
    ]);
  };
}
