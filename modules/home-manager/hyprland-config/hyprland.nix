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
      autostart = {
        content = ./autostart.lua;
      };
      config = {
        content = ./config.lua;
      };
      animations = {
        content = ./animations.lua;
      };
      keybinds = {
        content = ./keybinds.lua;
      };
      rules = {
        content = ./rules.lua;
      };

      user = {
        content = ../../../hosts/${hostname}/hyprland.lua;
      };
    };

    plugins = [
    ];
  };
}
