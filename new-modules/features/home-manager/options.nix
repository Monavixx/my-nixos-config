{
  flake.modules.homeManager.base = { lib, ... }: {
    options.my.flakeRoot = lib.mkOption {
      type = lib.types.strMatching "/.*";
      description = "Absolute path of the live checkout of this flake.";
    };
    options.my.hostname = lib.mkOption {
      type = lib.types.str;
      description = "Name of the NixOS host this Home Manager configuration belongs to.";
    };
  };
}
