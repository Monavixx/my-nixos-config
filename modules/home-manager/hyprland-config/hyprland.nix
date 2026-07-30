{
  pkgs,
  inputs,
  hostname,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = { };
    extraLuaFiles = {
      common = {
        content = ./common-hyprland.lua;
      };
      user = {
        content = ../../../hosts/${hostname}/hyprland.lua;
      };
    };
    #extraConfig =''
    #  ${builtins.readFile ./hyprland-config/common-hyprland.lua}
    #  ${builtins.readFile ../../hosts/${hostname}/hyprland.lua}
    #'';

    plugins = [
    ];
  };
}
