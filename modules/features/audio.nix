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

  flake.modules.nixos.audio-realtime = {
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-19";
      }
    ];
  };

  flake.modules.homeManager.audio =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pavucontrol ];
    };
}
