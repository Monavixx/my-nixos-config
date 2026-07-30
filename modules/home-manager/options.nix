{ lib, ... }:

{
  options.my = {
    flakeRoot = lib.mkOption {
      type = lib.types.str;
      description = "Path to the working copy of the NixOS configuration.";
    };
  };
}
