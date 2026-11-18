{
  den.aspects.kitty = {
    homeManager = {
      programs.kitty = {
        enable = true;
        settings = {
          allow_remote_control = "yes";
          background_opacity = "0.6";
          enable_audio_bell = false;
        };
      };
      catppuccin.kitty.enable = true;
      xdg = {
        terminal-exec = {
          enable = true;
          settings = {
            default = [ "kitty.desktop" ];
          };
        };
      };
    };
  };
}
