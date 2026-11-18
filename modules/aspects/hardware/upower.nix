{
  den.aspects.upower = {
    nixos = {
      services.upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 10;
      };
    };
  };
}
