{ config, pkgs, inputs, ...} :
{
  imports = [
    ../../modules/nixos/common.nix
    ./hardware-configuration.nix
  ];
  
  boot.initrd.luks.devices."luks-3815679e-a773-4c82-be2c-ca08327105af".device = "/dev/disk/by-uuid/3815679e-a773-4c82-be2c-ca08327105af";

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
  hardware.graphics = {
    package = hyprland-pkgs-unstable.mesa;
  };
}