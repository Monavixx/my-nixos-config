{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    package = null;
    portalPackage = null;

    settings = { };
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
