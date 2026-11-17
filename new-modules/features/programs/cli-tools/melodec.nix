{ inputs, ... }:
{
  flake.modules.homeManager.melodec = {
    # TODO: update melodec and write config
    imports = [
      inputs.melodec.homeManagerModules.default
    ];
  };
}
