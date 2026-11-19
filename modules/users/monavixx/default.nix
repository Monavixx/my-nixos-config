{ den, ... }:
{
  den.aspects.monavixx = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ]
    ++ (with den.aspects; [
      email
      hyprland
      nix-index
      kitty
      quickshell
      catppuccin
      rqbit
      libvirt
      reaper
      walker
      yazi
      mpd
      wallpapers
      poweralertd
      dsh
      firefox
      zsh
      direnv
      fastfetch
      starship
    ]);
  };

  homeManager =
    { config, ... }:
    {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
        pictures = "${config.home.homeDirectory}/pictures";
        videos = "${config.home.homeDirectory}/videos";
        music = "${config.home.homeDirectory}/music";
        download = "${config.home.homeDirectory}/downloads";
        documents = "${config.home.homeDirectory}/documents";
        desktop = null;
        projects = null;
        publicShare = null;
        templates = null;
      };
    };
}
