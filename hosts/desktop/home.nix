{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home-manager/common.nix
  ];
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  my.flakeRoot = "/home/monavixx/nixos";

  home.packages = with pkgs; [
    guitarix
  ];
}
