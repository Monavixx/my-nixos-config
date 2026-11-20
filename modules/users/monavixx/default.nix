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
      new-dotnet
      bat
      btop
      docker
      fzf
      git
      melodec
      mpv
      rebuild
      ripgrep
      taskwarrior
      trashy
      ayugram-desktop
      neovim
      aliases
      nh
      github-copilot-cli
    ]);

    homeManager =
      { config, pkgs, ... }:
      {
        xdg = {
          userDirs = {
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
          mimeApps.enable = true;
          configFile."mimeapps.list".force = true;
        };
        home.packages = with pkgs; [
          unzip
          bind
          statix
          deadnix
          streamrip
          vlc
          p7zip
          wev
          nodejs-slim_latest
          rmpc
          ffmpeg
          fd
          discord-canary
          libreoffice
          wl-clipboard
          grim
          slurp
          libnotify # notify-send
          obsidian
          bruno
        ];
      };
  };
}
