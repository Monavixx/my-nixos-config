{ pkgs, inputs, ... }:
let
  hyprland-pkgs-unstable =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ../../modules/nixos/common.nix
    ./hardware-configuration.nix
  ];

  fileSystems."/".options = [ "noatime" ];

  boot.initrd.luks.devices."luks-3815679e-a773-4c82-be2c-ca08327105af".device =
    "/dev/disk/by-uuid/3815679e-a773-4c82-be2c-ca08327105af";

  hardware.bluetooth.enable = true;
  services.upower.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
  hardware.graphics = {
    package = hyprland-pkgs-unstable.mesa;
  };
}
