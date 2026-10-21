{
  hostname,
  config,
  flakeRoot,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    package = null;
    portalPackage = null;

    extraConfig = ''
      require("autostart")
      require("config")
      require("animations")
      require("keybinds")
      require("rules")
      require("host")
    '';

    plugins = [
    ];
  };
  xdg.configFile."hypr/autostart.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/hyprland-config/autostart.lua";
  xdg.configFile."hypr/config.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/hyprland-config/config.lua";
  xdg.configFile."hypr/animations.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/hyprland-config/animations.lua";
  xdg.configFile."hypr/keybinds.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/hyprland-config/keybinds.lua";
  xdg.configFile."hypr/rules.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/hyprland-config/rules.lua";
  xdg.configFile."hypr/host.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/hosts/${hostname}/hyprland.lua";

}
