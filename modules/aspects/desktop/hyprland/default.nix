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
        nix.settings = {
          extra-substituters = [
            "https://hyprland.cachix.org"
          ];
          extra-trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          ];
        };
      };
    homeManager =
      {
        pkgs,
        lib,
        user,
        ...
      }:
      {
        home.sessionVariables = {
          SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
          GDK_BACKEND = "wayland";
          NIXOS_OZONE_WL = "1";
        };
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          xwayland.enable = true;
          package = null;
          portalPackage = null;
          # hl.on("hyprland.start", function()
          #     hl.exec_cmd("uwsm app -- qs -p /home/monavixx/nixos-den/quickshell")
          # end)
          extraConfig = ''
            require("autostart")
            require("config")
            require("animations")
            require("keybinds")
            require("rules")
            require("host")
          '';
          plugins = [ ];
        };

        programs.bash.profileExtra = lib.mkIf user.autostartHyprland (
          lib.mkAfter ''
            if uwsm check may-start; then
                exec uwsm start hyprland.desktop
            fi
          ''
        );
        programs.zsh.profileExtra = lib.mkIf user.autostartHyprland (
          lib.mkAfter ''
            if uwsm check may-start; then
                exec uwsm start hyprland.desktop
            fi
          ''
        );

        home.packages = [ pkgs.hyprpolkitagent ];
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
