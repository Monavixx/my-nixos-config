{
  pkgs,
  inputs,
  hostname,
  config,
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

    extraConfig = ''
      require("autostart")
      require("config")
      require("animations")
      require("keybinds")
      require("rules")
      require("host")
    '';
    # extraLuaFiles = {
    #   autostart = {
    #     content = ./autostart.lua;
    #   };
    #   config = {
    #     content = ./config.lua;
    #   };
    #   animations = {
    #     content = ./animations.lua;
    #   };
    #   keybinds = {
    #     content = ./keybinds.lua;
    #   };
    #   rules = {
    #     content = ./rules.lua;
    #   };
    #
    #   host = {
    #     content = ../../../hosts/${hostname}/hyprland.lua;
    #   };
    # };

    plugins = [
    ];
  };
  xdg.configFile."hypr/autostart.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/hyprland-config/autostart.lua";
  xdg.configFile."hypr/config.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/hyprland-config/config.lua";
  xdg.configFile."hypr/animations.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/hyprland-config/animations.lua";
  xdg.configFile."hypr/keybinds.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/hyprland-config/keybinds.lua";
  xdg.configFile."hypr/rules.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/home-manager/hyprland-config/rules.lua";
  xdg.configFile."hypr/host.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/hosts/${hostname}/hyprland.lua";

}
