{
  den.aspects.audio = {
    nixos = {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.pulseaudio.enable = false;
      security.rtkit.enable = true; # lets PipeWire get realtime scheduling
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.pavucontrol

          # Run jack-programs by `pw-jack <run-command>`
          pkgs.pipewire.jack
        ];
        services.playerctld.enable = true;
      };
  };
}
