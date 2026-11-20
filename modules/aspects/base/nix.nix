{
  den.aspects.nix.nixos = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };
    };
    nix.settings = {
      trusted-users = [ "@wheel" ];
    };
  };
}
