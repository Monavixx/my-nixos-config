{
  flake.modules.homeManager.base = { lib, ... }: {
    options.my.flakeRoot = lib.mkOption {
      type = lib.types.strMatching "/.*";
      description = "Absolute path of the live checkout of this flake.";
    };
  };
}
