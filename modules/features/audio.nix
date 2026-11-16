{
  flake.modules.nixos.audio = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true; # lets PipeWire get realtime scheduling
  };

  flake.modules.homeManager.audio =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pavucontrol ];
    };
}
