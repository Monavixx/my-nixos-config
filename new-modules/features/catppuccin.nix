{ inputs, ... }:
{
  flake.modules.homeManager.theming =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      home.packages = [
        inputs.catppuccin.packages.${system}.whiskers
      ];
    };
}
