{ config, ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
  };
  services.mpdris2.enable = true;
}
