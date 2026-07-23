{ config, pkgs, inputs, ...} :
{
  imports = [
    ../../modules/nixos/common.nix
    ./hardware-configuration.nix
  ];
}