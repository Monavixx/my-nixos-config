{ ... }:
let
in
{
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  home.sessionPath = [
  ];

  imports = [
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

  #xdg.mimeApps = {
  #  enable = true;
  #  defaultApplications = {
  #    "application/json" = "dev.zed.Zed.desktop";
  #    "application/schema+json" = "dev.zed.Zed.desktop";
  #  };
  #};

  programs.hyprlock.enable = true;
  programs.bash.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
