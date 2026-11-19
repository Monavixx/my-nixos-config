{
  den.aspects.audio = {
    nixos = {
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

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.pavucontrol ];
        services.playerctld.enable = true;
      };
  };
}
