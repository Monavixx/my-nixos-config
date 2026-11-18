{ inputs, ... }:
{
  den.aspects.agenix.homeManager.imports = [
    inputs.agenix.homeManagerModules.default
  ];
}
