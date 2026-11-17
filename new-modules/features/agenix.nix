{ inputs, ... }:
{
  flake.modules.homeManager.agenix = {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];
  };
}
