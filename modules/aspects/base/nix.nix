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
      # extra-substituters = [
      #   "https://ayugram-desktop.cachix.org"
      #   "https://cache.numtide.com"
      # ];
      # extra-trusted-public-keys = [
      #   "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
      #   "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      # ];
    };
  };
}
