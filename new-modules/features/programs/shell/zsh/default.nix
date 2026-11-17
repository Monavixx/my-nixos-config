{
  flake.modules.nixos.zsh = { pkgs, ... }: {
    programs.zsh.enable = true;
    environment = {
      shells = [ pkgs.zsh ];
    };
  };
}
