{ config, ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };
  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
  };
}
