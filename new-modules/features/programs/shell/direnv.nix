{
  flake.modules.homeManager.direnv = {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
