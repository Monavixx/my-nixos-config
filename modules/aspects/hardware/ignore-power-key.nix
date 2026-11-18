{
  den.aspects.ignore-power-key.nixos = {
    # the compositor handles the power key, not logind
    services.logind.settings.Login.HandlePowerKey = "ignore";
  };
}
