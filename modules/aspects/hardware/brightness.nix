{
  den.aspects.brightness.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
