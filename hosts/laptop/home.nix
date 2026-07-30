{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  my.flakeRoot = "/home/monavixx/nixos";

  imports = [
    ../../modules/home-manager/common.nix
  ];

  home.packages = with pkgs; [
  ];
}
