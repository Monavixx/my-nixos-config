{
  inputs,
  username,
  hostname,
  config,
  ...
}:
{
  home = {
    stateVersion = "26.05";
    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
      GDK_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
      QS_HOST_TYPE = hostname;
      GROQ_API_KEY = "$(cat ${config.age.secrets.groq.path})";
    };
    sessionPath = [
    ];
  };
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  imports = [
    ./ayugram-desktop/ayugram-desktop.nix
    ./ripgrep.nix
    inputs.nix-index-database.homeModules.default
    ./firefox.nix
    ./quickshell/default.nix
    ./bat.nix
    ./fzf.nix
    ./trashy.nix
    ./reaper.nix
    ./agenix.nix
    ./email.nix
    ./starship.nix
    ./shell/default.nix
    ./walker.nix
    ./nh.nix
    ./btop.nix
    ./custom-commands/rebuild/rebuild.nix
    ./melodec.nix
    inputs.melodec.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
    ./custom-commands/new-dotnet/new-dotnet.nix
    ./mpd.nix
    ./kitty.nix
    ./yazi.nix
    ./mpv.nix
    ./git.nix
    ./theme.nix
    ./packages.nix
    ./wlogout.nix
    ./neovim/neovim.nix
    ./awww.nix
    # ./hourly-productivity-control.nix
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
