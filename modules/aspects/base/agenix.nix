{ inputs, ... }:
{
  den.aspects.agenix.homeManager = { pkgs, ... }: {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];
    home.packages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
