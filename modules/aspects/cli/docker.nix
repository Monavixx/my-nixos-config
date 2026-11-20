{
  den.aspects.docker = {
    nixos = {
      virtualisation.docker = {
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
    user.extraGroups = [ "docker" ];
  };
}
