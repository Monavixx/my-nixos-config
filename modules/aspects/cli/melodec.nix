{ inputs, ... }:
{
  den.aspects.melodec.homeManager = {
    # TODO: update melodec and write config
    imports = [
      inputs.melodec.homeManagerModules.default
    ];
  };
}
