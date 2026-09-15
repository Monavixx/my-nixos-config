{ inputs, ... }:
let
in
{
  home.stateVersion = "26.05";

  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  home.sessionPath = [
  ];

  imports = [
    ./melodec.nix
    inputs.melodec.homeManagerModules.default
    ./custom-commands/new-dotnet.nix
    ./streamrip.nix
    ./mpd.nix
    ./options.nix
    ./kitty.nix
    ./yazi.nix
    ./vicinae.nix
    ./mpv.nix
    ./git.nix
    ./theme.nix
    ./packages.nix
    ./wlogout.nix
    ./neovim/neovim.nix
    ./awww.nix
    ./hourly-productivity-control.nix
    ./waybar.nix
    ./hyprland-config/hyprland.nix
  ];
  programs.home-manager.enable = true;

  services.swaync = {
    enable = true;
  };

  services.playerctld.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/json" = "nvim.desktop";
      "application/schema+json" = "nvim.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "kitty.desktop" ];
    };
  };

  programs.hyprlock.enable = true;
  programs.bash.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
