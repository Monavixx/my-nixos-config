{
  den.aspects.desktop = {
    nixos = {
      imports = [ ./_hardware-configuration.nix ];
    };
  };
}
