{
  flake.modules.homeManager.ripgrep = {
    # adds 'rg' commads which is a faster alternative to grep
    programs.ripgrep = {
      enable = true;
    };
  };
}
