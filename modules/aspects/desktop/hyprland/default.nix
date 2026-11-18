{ inputs, den, ... }:
{
  den.aspects.hyprland = {
    includes = with den.aspects; [
      desktop-session
      ignore-power-key
    ];
    nixos =
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        hyprland = inputs.hyprland.packages.${system};
      in
      {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
          xwayland.enable = true;
          package = hyprland.hyprland;
          portalPackage = hyprland.xdg-desktop-portal-hyprland;
        };
      };
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          xwayland.enable = true;
          package = null;
          portalPackage = null;
          # TODO: finish quickshell config and run it from the store instead of repo
          extraConfig = ''
            hl.on("hyprland.start", function()
                hl.exec_cmd("uwsm app -- qs -p /home/monavixx/nixos-den/quickshell")
            end)
            require("autostart")
            require("config")
            require("animations")
            require("keybinds")
            require("rules")
            require("host")
          '';
          plugins = [ ];
        };

        programs.bash.profileExtra = lib.mkAfter ''
          if uwsm check may-start; then
              exec uwsm start hyprland.desktop
          fi
        '';
        programs.zsh.profileExtra = lib.mkAfter ''
          if uwsm check may-start; then
              exec uwsm start hyprland.desktop
          fi
        '';

        home.packages = [ pkgs.hyprpolkitagent ];
        # TODO: Before switching to this config, remove all current home-manager symlinks
        xdg.configFile = {
          "hypr/shaders" = {
            source = ./shaders;
            recursive = true;
          };
          "hypr" = {
            source = ./config;
            recursive = true;
          };
        };
      };
  };
}
