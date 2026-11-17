{ config, ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = config.xdg.userDirs.music;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };
  services.mpdris2 = {
    enable = true;
    settings.Bling.mmkeys = true;
  };
}
