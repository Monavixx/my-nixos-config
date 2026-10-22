{ inputs, username, ... }:
{
  home.stateVersion = "26.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  home.sessionPath = [
  ];

  imports = [
    ./nh.nix
    ./btop.nix
    ./custom-commands/rebuild/rebuild.nix
    ./melodec.nix
    inputs.melodec.homeManagerModules.default
    ./custom-commands/new-dotnet/new-dotnet.nix
    ./mpd.nix
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
    ./xdg.nix
  ];

  services.swaync = {
    enable = true;
  };

  services.playerctld.enable = true;

  programs.hyprlock.enable = true;
  programs.bash = {
    enable = true;
    profileExtra = ''
      if uwsm check may-start; then
          exec uwsm start hyprland.desktop
      fi
    '';
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
